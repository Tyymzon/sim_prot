extends CharacterBody2D


const SPEED = 300.0
@onready var Display = get_node("../CanvasLayer/Control/PlayerLabel")
@onready var Entites = get_tree().get_nodes_in_group("Entity")
var cash = 20
var hunger = 60.0
func _physics_process(delta: float) -> void:
	###movement
	velocity = Input.get_vector("left", "right", "up", "down").normalized()
	velocity *= SPEED
	if get_node("../CanvasLayer/Cheats").text == "":
		move_and_slide()
	###Interact
	for i in Entites:
		if global_position.distance_to(i.global_position) < 120:
			$"../InteractPrompt".visible = true
			$"../InteractPrompt".global_position = i.global_position + Vector2(0, -20)
			if Input.is_action_just_pressed("interact"):
				i.Interact()
		else:
			$"../InteractPrompt".visible = false
			




func _process(delta: float) -> void:
	hunger = clampf(hunger, 0, 100)
	Display.text = "Cash: " + str(cash) + "\nHunger: " + str(int(hunger))
	
	

func _on_tick() -> void:
	hunger -= 0.1
	pass # Replace with function body.
