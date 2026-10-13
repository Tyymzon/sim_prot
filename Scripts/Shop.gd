extends Node2D
signal new_shop

###Shop ID:
@onready var ShopId = 1
@onready var workers = [0, 0]
### Owners:
# -1 = State
# 0 = Player
# 1, 2, 3, ... = NPC by ID
#
#
@onready var ShopOwnerid = -1
### Types:
#Grocery = 0
@onready var Type = 0
### Stock:
#[[Item, ammount, price, demand], [Item, ammount, price, demand]]
@onready var stock = [[1,10,1,0],[2,25,2,0]]
### Open
#Shop open/close
var Open = false

var max_stock = 50

var Open_temp = false

@onready var Town_hall = get_node("../../Town Hall")

@onready var Owner_node: Node = Global.get_npc_id(ShopOwnerid)
### Wage
#how much do they pay
var wage = 20
### Mode
#0 - only earlyshift, 1 - only lateshift, 2 - allshifts
var mode = 2

func _ready() -> void:
	emit_signal("new_shop")




func worker_enter(id: int):
	if Open == false:
		Open = true
	else:
		Open_temp = true

func worker_leave(id: int):
	Open = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Open_temp and Open == false:
		Open_temp = false
		Open = true
	pass

#npc_id: npc id, money: cash, 
func _npc_buy(npc: Node, house:Node, house_num: int, special: bool):
	################Prepare info
	var item = 0 if special else 1
	if not Open:
		return false
	var buy_qty = 1
	if not special and npc.cash >= stock[item][2] and stock[item][1] > 1:
		buy_qty = 2
	var cost = stock[item][2] * buy_qty
	if npc.cash < cost:
		return false
	################Transaction
	npc.cash -= cost
	stock[item][1] -= buy_qty
	stock[item][3] += buy_qty
	if ShopOwnerid == -1:
		Town_hall.state_money += cost
	elif ShopOwnerid > 0:
		Owner_node.cash += cost
	
	if Type == 0 and !special:
		house.food[house_num][0] += 1
	return true

func Interact():
	if Open:
		$"../../CanvasLayer/BuyMenu".open(ShopId)
	else:
		print("The door is closed")
	pass

func restock():
	'''
	General shop maintenance
	1 - reprice
	2 - restock
	'''
	var money: int
	#if owner is state
	if ShopOwnerid == 0:
		return
	elif ShopOwnerid == -1:
		money = Town_hall.state_money
	else:
		money = Owner_node.cash
		
	for i in stock:
		###1. Setting prices
		#stock ratio (float 0 to 1)
		var stock_ratio = clamp(float(i[1]) / max_stock, 0.0, 1.0)
		#Calculate demand pressure (0 = low, 1 = high)
		var demand_pressure = min(1.0, float(i[3]) / (i[1] + 1))
		# Dynamic margin calculation
		var dynamic_margin = 0.3 + (0.6 * demand_pressure) - (0.4 * stock_ratio)
		 # Apply constraints
		var final_margin = clamp(dynamic_margin, 0.1, 2.5)
		 # Final price
		i[2] = ceili(Global.Global_Prices[i[0]] * (1.0 + final_margin))
		###2. Buying up stock
		if i[1] < clampi(ceili(i[3] * 1.1) - i[1], 0, max_stock): #if stock < demand
			var rest: int
			if clampi(ceili(i[3] * 1.1) - i[1], 0, max_stock) * Global.Global_Prices[i[0]] > money: #if cannot afford full stock
				rest = floor(money * 0.75 / Global.Global_Prices[i[[0]]])
			else: #if can afford, buy 110% of demand
				rest = clampi(ceili(i[3] * 1.1) - i[1], 0, max_stock)
			i[3] = 0 #reset demand
			money -= Global.Global_Prices[i[0]] * rest
			i[1] += rest
		var default_price = Global.Global_Prices[i[0]]
	if ShopOwnerid == -1:
		Town_hall.state_money = money
	else:
		Owner_node.cash = money
	return

func fire(who: int):
	var npc = Global.get_npc_id(workers[who])
	npc.job = 0
	npc.job_node = npc
	npc.timetable = [0, 0]
	workers[who] = 0
	pass

func hire(who: Node, type: int):
	if type == 1:
		workers[0] = who.name
	elif type == 2:
		workers[1] = who.name
	return

func payment(npc: Node):
	var money: int
	if ShopOwnerid == 0:
		return
	elif ShopOwnerid == -1:
		money = Town_hall.state_money
	else:
		money = Owner_node.cash
	
	if money >= wage:
		money -= wage
		npc.cash += wage
	elif mode > 0: #if you can't pay, downsize
		mode -= 1
		fire(abs(mode - 1)) #fire through this weird script XD (if 1 -> fire 0, if 0 -> fire 1)
	
	if ShopOwnerid == -1:
		Town_hall.state_money = money
	else:
		Owner_node.cash = money
	pass
