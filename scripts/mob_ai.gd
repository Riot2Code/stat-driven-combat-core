# scripts/mob_ai.gd
class_name MobAI
extends Actor

@export var move_speed: float = 140.0
@export var aggro_range: float = 350.0
@export var leash_range: float = 500.0

signal attempt_attack(attacker: Actor, target: Actor)

@export var attack_range: float = 70.0
@export var attack_cooldown: float = 1.0

var _attack_cd_left: float = 0.0

var _spawn_pos: Vector2
var _target: Node2D

func _ready() -> void:
	super._ready()
	_spawn_pos = global_position

func set_target(t: Node2D) -> void:
	_target = t

func _physics_process(delta: float) -> void:
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

	_attack_cd_left = maxf(0.0, _attack_cd_left - delta)
	
	if is_dead():
		return
	if _target == null:
		return
	if _attack_cd_left > 0.0:
		return
		
	var t := _target as Actor
	if t == null:
		return
	if t.is_dead():
		return

	var dist := global_position.distance_to(t.global_position)
	if dist <= attack_range:
		_attack_cd_left = attack_cooldown
		attempt_attack.emit(self, t)

	move_and_slide()
# TODO: attack_range
# TODO: attack cooldown
# TODO: emit attack signal
