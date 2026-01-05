# scripts/player_controller.gd
class_name PlayerController
extends Actor

@export var move_speed: float = 220.0

func _physics_process(_delta: float) -> void:
	var input := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	velocity = input * move_speed
	move_and_slide()
