extends Node2D

@onready var available: int = 4
@onready var occupants : Array
#((jedzenie basic, jedzenie premium), (jedzenie basic, jedzenie premium), apartament2, apartament 3)
var food = [[0,0], [0,0], [0,0], [0,0]]
var level = [0, 0, 0, 0]

func _ready() -> void:
	pass # Replace with function body.


func check_occ():
	available = 4 - len(occupants)
	if available > 0:
		available -= 1
		return true
	else:
		return false


func move_in(id: int):
	occupants.append(id)


func _process(delta: float) -> void:
	pass
