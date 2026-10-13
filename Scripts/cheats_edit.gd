extends TextEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		self.text = ''
		release_focus()
	if Input.is_action_just_pressed("enter"):
		text = text.to_lower().replace("\n", "")
		var command = text.split(' ')
		self.text = ''
		release_focus()
		#komendy
		if command[0] == "time":
			if len(command) >= 2 and command[1] == "set":
				if len(command) >= 3 and  command[2].is_valid_int():
					$"../..".time = int(command[2])
				else:
					print("Nie można ustawić następującego czasu: %s" % [command[2]])
			else:
				print("Nie znaleziono podkomendy %s dla komendy time" % [command[1]])
		elif command[0] == "get":
			if len(command) >= 2 and  command[1] == "agent":
				if len(command) >= 3 and  command[2] == "name":
					if len(command) >= 4 and  command[3].is_valid_int():
						var agent = Global.get_npc_id(int(command[3]))
						print(Global.male_name[agent.Fname], Global.male_name[agent.Lname])
					else:
						print("Brakuje podkomendy po: %s" % [command[-1]])
				else:
					print("Brakuje podkomendy po: %s" % [command[-1]])
			else:
				print("Brakuje podkomendy po: %s" % [command[-1]])
				
		else:
			print("Nie znaleziono następującej komendy: %s" % [command[0]])
	pass
