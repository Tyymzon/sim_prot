extends Node

@onready var male_name_path = "res://Scripts/Male_Names.txt"
@onready var female_name_path = "res://Scripts/Female_Names.txt"
@onready var surnames_path = "res://Scripts/Surnames.txt"
var male_name = []
var female_name = []
var surnames = []

func load_file(file):
	var f = FileAccess.open(file, FileAccess.READ)
	return (f.get_as_text()).split("\n")

const Item = [
"Food",
"Giga Food"
]

const Relation_type = {"NEIGHBOUR" : 5, "COWORKER" : 5, "ROOMMATE" : 15, "DEBUG_FRIENDLY" : 100, "DEBUG_EVIL" : -100}



###Default hours for jobs
#1 = shopkeeper first half
#2 = shopkeeper second half
var Job_Timetable = [null, Vector2(5, 13), Vector2(13, 21)]

##Global prices:
#1.food
#2.better food (WIP)
var Global_Prices = [null, 3, 5]

func _ready() -> void:
	male_name = load_file(male_name_path)
	female_name = load_file(female_name_path)
	surnames = load_file(surnames_path)

func get_npc_id(ID: int):
	return get_tree().root.get_node("City/NPCS/" + str(ID))
