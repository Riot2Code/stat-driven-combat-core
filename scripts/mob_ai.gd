# scripts/mob_ai.gd
class_name MobAI
extends Actor

@export var move_speed: float = 140.0
@export var aggro_range: float = 350.0
@export var leash_range: float = 500.0

var _spawn_pos: Vector2
var _target: Node2D

func _ready() -> void:
	super._ready()
	_spawn_pos = global_position

func set_target(t: Node2D) -> void:
	_target = t

func _physics_process(_delta: float) -> void:
	if is_dead():
		velocity = Vector2.ZERO
		return

	if _target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dist_to_target := global_position.distance_to(_target.global_position)
	var dist_from_spawn := global_position.distance_to(_spawn_pos)

	# If you kite too far, mob returns home (classic leash)
	if dist_from_spawn > leash_range:
		var dir_home := (_spawn_pos - global_position).normalized()
		velocity = dir_home * move_speed
		move_and_slide()
		return

	# Aggro if close enough
	if dist_to_target <= aggro_range:
		var dir := (_target.global_position - global_position).normalized()
		velocity = dir * move_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
