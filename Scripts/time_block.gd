class_name Time_Block

var prio: int
var start: int
var end: int
var dest: Node
var press: bool
func _init(priority: int, time_start: int, time_end: int, loc: Node, interact: bool) -> void:
	self.prio = priority
	self.start = time_start
	self.end = time_end
	self.dest = loc
	self.press = interact

func is_active(current_time: int) -> bool:
	return current_time >= start and current_time <= end
