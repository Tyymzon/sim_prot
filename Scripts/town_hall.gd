extends Node2D
var state_money = 2000
var job_list:Array

class job:
	var node
	var pay
	var hours
	var type
	func _init(node, pay, hours, type) -> void:
		self.node = node
		self.pay = pay
		self.hours = hours
		self.type = type
		
	func score():
		var score: float
		score = self.pay / (self.hours[1] - self.hours[0])
		return score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func worker_enter(id: int):
	pass

func worker_leave(id: int):
	pass

func Interact():
	pass

func find_job(pop: Node):
	if job_list.size() > 0:
		var score = []
		for i in job_list:
			score.append(i.score())
		var index = score.find(score.max)
		var work = job_list[index]
		pop.job = work.type
		pop.job_node = work.node
		(work.node).hire(pop, work.type)
		job_list.pop_at(index)
		return true
	else:
		return false

func _fill_job_list() -> void:
	job_list.clear()
	var shops = get_tree().get_nodes_in_group("Shop")
	###Shops
	for i in shops:
		var type = i.mode
		var wage = i.wage
		
		match i.mode:
			2:
				if i.workers[0] == 0:
					type = 1
					var timetable = Global.Job_Timetable[type]
					var fin = job.new(i, wage, timetable, type)
					job_list.append(fin)
				if i.workers[1] == 0:
					type = 2
					var timetable = Global.Job_Timetable[type]
					var fin = job.new(i, wage, timetable, type)
					job_list.append(fin)
			0:
				if i.workers[0] == 0:
					type = 1
					var timetable = Global.Job_Timetable[type]
					var fin = job.new(i, wage, timetable, type)
					job_list.append(fin)
			1:
				if i.workers[1] == 0:
					type = 2
					var timetable = Global.Job_Timetable[type]
					var fin = job.new(i, wage, timetable, type)
					job_list.append(fin)
		if type == 0:
			continue
	###Something else
	#TODO
	pass

func _get_house(ID_node: Node):
	var houses = get_tree().get_nodes_in_group("House")
	var ID = ID_node.ID
	for house_candidate in houses:
		if house_candidate.has_method("check_occ") and house_candidate.check_occ():
			ID_node.house_node = house_candidate
			house_candidate.move_in(ID)
			ID_node.house_num = house_candidate.occupants.find(ID)
			ID_node.global_position = ID_node.house_node.global_position #DEBUG teleports to house
			###Add relations
			for i in house_candidate.occupants:
				RelationshipManager.add_relations(ID, i, "NEIGHBOUR")
			return

func _on__new_shop() -> void:
	_fill_job_list()
	print(job_list)
	pass # Replace with function body.
