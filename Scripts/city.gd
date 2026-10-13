extends Node2D

signal time_changed

@onready var agent = preload("res://agent.tscn")
@onready var NavMap = get_node("NavigationRegion2D")
@onready var TimeLabel = get_node("CanvasLayer/Control/Label")
@onready var Ticker = get_node("Ticker")
@onready var Town_hall = get_node("Town Hall")
@onready var time = 340

func _ready() -> void:
	#await get_tree().create_timer(0.01).timeout
	NavMap.bake_navigation_polygon()
	for i in range(1, 10):
		var new_agent = agent.instantiate()
		new_agent.set_name(str(i))
		new_agent.ID = i
		new_agent.sex = "male" if randf() < 0.5 else "female"
		new_agent.Fname = randi_range(0, Global.male_name.size()) if new_agent.sex == "male" else randi_range(0, Global.female_name.size())
		new_agent.Lname = randi_range(0, Global.surnames.size())
		$NPCS.add_child(new_agent)
		Town_hall.find_job(new_agent)
		
func _process(delta: float) -> void:
	###Clock/time
	##################################
	var hour = str(floor(time / 60))
	var minute = str(time % 60)
	if int(hour) < 10:
		hour = '0' + hour
	if int(minute) < 10:
		minute = '0' + minute
	TimeLabel.text = hour + ":" + minute
	if time == 1440:
		time = 0
		_day_tick()
	##################################
	
func _on_tick() -> void:
	time += 1
	emit_signal("time_changed")
	pass # Replace with function body.


func _day_tick():
	#Shop restock
	var Shops = get_tree().get_nodes_in_group("Shop")
	for curr in Shops:
		curr.restock()
	pass
	
	
