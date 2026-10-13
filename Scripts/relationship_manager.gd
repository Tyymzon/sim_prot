extends Node



class relations:
	var id1:int
	var id2:int
	var memories:Array = []
	var relations:int = 0
	func _init(ID_1: int, ID_2:int):
		self.id1 = ID_1
		self.id2 = ID_2
		self.memories = []
		self.relations = 0
	
	func add(value:String):
		if Global.Relation_type.has(value):
			self.relations += Global.Relation_type.get(value)
			self.memories.append(value + " " + str(Global.Relation_type.get(value))) #Add (Name of memory, value) to array
			return true
		else:
			push_error("Unknown memory type: ", value)
			return false
	
	func _check(ID_1:int, ID_2:int):
		return (self.id1 == ID_1 and self.id2 == ID_2) or (self.id1 == ID_2 and self.id2 == ID_1)
	
	func pull_relations():
		return self.relations
	
	func pull_memory():
		return self.memories


var list = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_for_relationship(id1:int, id2:int):
	for i in list:
		if i._check(id1, id2):
			return true
	return false

func add_relations(id1:int, id2:int, memory:String):
	if id1 == id2:
		push_error("Can't create relations with self")
		return false
	for i in list:
		if i._check(id1, id2):
			i.add(memory)
			return true
	#Didn't find the pair, create one
	var new_relation = relations.new(id1, id2)
	list.append(new_relation)
	new_relation.add(memory)
	return false
