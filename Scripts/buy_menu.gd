extends Control

@onready var using = false

@onready var Label1 = get_node("Product1")
@onready var Label2 = get_node("Product2")
@onready var Label3 = get_node("Product3")
@onready var shop_used = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = using
	if using:
		if shop_used.stock[0][0] == 0:
			Label1.text = "None"
		else:
			Label1.text = Global.Item[shop_used.stock[0][0]-1]
			Label1.text += "\nAmmount: " + str(shop_used.stock[0][1]) + "\nPrice: " + str(shop_used.stock[0][2])
		###
		if shop_used.stock[1][0] == 0:
			Label2.text = "None"
		else:
			Label2.text = Global.Item[shop_used.stock[1][0]-1]
			Label2.text += "\nAmmount: " + str(shop_used.stock[1][1]) + "\nPrice: " + str(shop_used.stock[1][2])
		###
		
		if Input.is_action_just_pressed("exit_UI"):
			using = false
	
	pass



func open(ShopId : int):
	shop_used = get_node("../../Shops/" + str(ShopId))
	using = true
	pass



func _on_buy_1_pressed() -> void:
	if visible and shop_used.stock[0][1] > 0 and shop_used.stock[0][2] <= $"../../Playerchar".cash:
		shop_used.stock[0][1] -= 1
		$"../../Playerchar".cash -= shop_used.stock[0][2]
		shop_used.stock[0][3] += 1
	pass # Replace with function body.


func _on_buy_2_pressed() -> void:
	if visible and shop_used.stock[1][1] > 0 and shop_used.stock[1][2] <= $"../../Playerchar".cash:
		shop_used.stock[1][1] -= 1
		$"../../Playerchar".cash -= shop_used.stock[1][2]
		shop_used.stock[1][3] += 1
	pass # Replace with function body.


func _on_buy_3_pressed() -> void:
	if visible and shop_used.stock[2][1] > 0 and shop_used.stock[2][2] <= $"../../Playerchar".cash:
		shop_used[2][1] -= 1
		$"../../Playerchar".cash -= shop_used[2][2]
	pass # Replace with function body.
