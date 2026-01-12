extends Node2D
class_name MobSpawner

@export var mob_scene: PackedScene
@export var mob_count: int = 6
@export var spawn_center: Vector2 = Vector2.ZERO
@export var spawn_radius: float = 220.0

var mobs: Array[MobAI] = []

func spawn_all(target: Actor, on_attack_cb: Callable) -> void:
	clear()

	if mob_scene == null:
		push_error("MobSpawner: mob_scene not set")
		return

	for i in range(mob_count):
		var mob := mob_scene.instantiate() as MobAI
		if mob == null:
			push_error("MobSpawner: mob_scene root is not MobAI")
			return

		add_child(mob)
		mob.global_position = random_spawn_pos()
		mob.set_target(target)
		mob.attempt_attack.connect(on_attack_cb)

		mob.stats.name = "Mob %d" % (i + 1)
		mobs.append(mob)

func respawn(mob: MobAI) -> void:
	if not is_instance_valid(mob):
		return
	mob.stats.hp = mob.stats.max_hp
	mob.global_position = random_spawn_pos()

func clear() -> void:
	for m in mobs:
		if is_instance_valid(m):
			m.queue_free()
	mobs.clear()

func get_nearest_alive(target: Actor) -> MobAI:
	var best: MobAI = null
	var best_dist := INF

	for m in mobs:
		if not is_instance_valid(m) or m.is_dead():
			continue
		var d := target.global_position.distance_to(m.global_position)
		if d < best_dist:
			best_dist = d
			best = m

	return best

func random_spawn_pos() -> Vector2:
	var angle := randf() * TAU
	var r := sqrt(randf()) * spawn_radius
	return spawn_center + Vector2(cos(angle), sin(angle)) * r
