extends CharacterBody2D



var speed = 300

@onready var NavAgent = get_node("NavigationAgent2D")
@onready var city = get_node("../..")
@onready var town_hall = get_node("../../Town Hall")
@onready var ID: int

enum LocationState {HOME, WORK, TRAVELING, IN_STORE}
enum FreeTimeState {START, FINANCE, SHOPPING, TRAVEL_TO_SHOP, RETURN, IDLE}

var where: LocationState = LocationState.HOME

var interact: Node = self

var sex = "male"
var Fname = 7
var Lname = 1
var cash = 20
var hunger = 65
#
var boredom = 65

var friend_list = []



#What job
var job = 0
#level
var house = 0

#Timetable: leave for work, leave for home
var timetable: Array[Time_Block] = []
var current_block = null
#const pixels_per_second = 200

var travel_target: Vector2 = Vector2.ZERO

var house_node = self
var house_num: int

var job_node = self

func redo_timetable():
	pass


func find_shop(type: int):
	'''
	Returns the closest shop
	args: type - 0 = food/kiosk, 1 = electronics
	'''
	var score = INF
	var fin = self
	var shops = get_tree().get_nodes_in_group("Shop")
	var distances = []
	var prices = []
	for i in shops:
		distances.append(global_position.distance_to(i.global_position))
		prices.append(i.stock[0][2])
	if shops.size() == 0:
		return self
	var min_dist: float = distances.min()
	var max_dist: float = distances.max()
	var min_price: float = prices.min()
	var max_price: float = prices.max()
	
	var dist_range = max_dist - min_dist if max_dist != min_dist else 1.0
	var price_range = max_price - min_price if max_price != min_price else 1.0
	for i in shops.size():
		if not shops[i].Open or shops[i].Type != type:
			print("SKIP")
			continue
		var norm_dist: float = (distances[i] - min_dist) / dist_range
		
		var norm_price: float = (prices[i] - min_price) / price_range
		
		var curr: float = (0.4 * norm_dist) + (0.6 * norm_price)
		if curr < score:
			score = curr
			fin = shops[i]
			
	return fin


func _ready() -> void:
	if house_node == self:
		town_hall._get_house(self)
	pass

func _process(delta: float) -> void:
	#TODO runs every frame, change to only happen when time ticks (potential performance hit!!!)
	#Every 15 ticks check if the timetable changed
	if city.time % 15 == 0:
		_evaluate_timetable()
	pass
	

func _evaluate_timetable() -> void:
	var current_time = city.time
	var best: Time_Block = null

	var lo = 0
	var hi = timetable.size() - 1
	var first_candidate = -1
	
	###binary search
	while lo <= hi:
		#@warning_ignore("integer_division") 
		var mid = (lo + hi) >> 1 #like java
		if timetable[mid].start <= current_time:
			first_candidate = mid
			lo = mid + 1
		else:
			hi = mid - 1

	for i in range(first_candidate, -1, -1):
		var block = timetable[i]
		if not block.is_active(current_time):
			continue
		if best == null or block.prio > best.prio:
			best = block

	if best != current_block:
		current_block = best
		_on_block_changed(current_block)

func _on_block_changed(block: Time_Block) -> void:
	if block == null:
		# agent is idle
		return
	start_travel(block.dest.global_position)
	

func free_time():
	###free time
	#Priority:
	#1. Manage finances
	#2. if no food at home - get food
	#3. if bored -> decide to do something fun (to be determined)
	#4. 
	#5. 
	#priority: finance -> check food, if food go get it -> idle
	pass

#insert into a sorted array
func add_block(prio: int, start: int, end: int, loc: Node, interact: bool) -> void:
	var new_block := Time_Block.new(prio, start, end, loc, interact)
	for i in timetable.size():
		if timetable[i].start > start:
			timetable.insert(i, new_block)
			return
	timetable.append(new_block)
	if new_block.is_active(city.time):
		_evaluate_timetable()



func _physics_process(delta: float) -> void:
	###Movement
	if where == LocationState.TRAVELING and not NavAgent.is_navigation_finished():
		velocity = global_position.direction_to(NavAgent.get_next_path_position()) * speed
		move_and_slide()


func start_travel(target: Vector2):
	if where == LocationState.TRAVELING:
		return
	travel_target = target
	NavAgent.target_position = target
	where = LocationState.TRAVELING

func _finance_manage():
	###
	#Food:
	#if food = 0 -> go buy food
	#
	
	pass
