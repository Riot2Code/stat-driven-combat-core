# scripts/player_controller.gd
class_name PlayerController
extends Actor

@export var move_speed: float = 220.0

# Attack modes (drag AttackProfile .tres files into this array)
@export var attacks: Array[AttackProfile] = []
var attack_index: int = 0

func get_attack() -> AttackProfile:
	if attacks.is_empty():
		return null
	return attacks[clampi(attack_index, 0, attacks.size() - 1)]

func set_attack_index(i: int) -> void:
	if attacks.is_empty():
		return
	attack_index = clampi(i, 0, attacks.size() - 1)
	print("Attack mode:", get_attack().display_name)

func _physics_process(_delta: float) -> void:
	var input := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	velocity = input * move_speed
	move_and_slide()
