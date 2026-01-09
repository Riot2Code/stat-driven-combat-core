#scripts/arena.gd
extends Node2D

@export var player_path: NodePath
@export var mob_path: NodePath
@export var resolver_path: NodePath
@export var vfx_parent_path: NodePath

@onready var player: PlayerController = get_node_or_null(player_path)
@onready var mob: MobAI = get_node_or_null(mob_path)
@onready var resolver: CombatResolver = get_node_or_null(resolver_path)
@onready var _vfx_parent: Node = get_node_or_null(vfx_parent_path)



var xp: int = 0
var xp_to_next: int = 10

const FloatingTextScene := preload("res://scenes/FloatingText.tscn")

func _ready() -> void:
	if player == null or mob == null or resolver == null:
		push_error("Arena wiring is missing. Check NodePaths.")
		return

	if _vfx_parent == null:
		_vfx_parent = get_tree().current_scene

	mob.set_target(player)
	print("Arena ready. Kite and press SPACE to attack.")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		_handle_attack()

	if event.is_action_pressed("attack_mode_1"):
		player.set_attack_index(0)
		queue_redraw()

	if event.is_action_pressed("attack_mode_2"):
		player.set_attack_index(1)
		queue_redraw()

	if event.is_action_pressed("drop_test"):
		drop_item_from_player("ring_godot", 1)

func _handle_attack() -> void:
	if player == null or mob == null or resolver == null:
		return

	if mob.is_dead():
		print("Mob is dead.")
		return

	var profile: AttackProfile = player.get_attack()
	if profile == null:
		push_error("Player has no AttackProfile assigned.")
		return

	var dist: float = player.global_position.distance_to(mob.global_position)
	if dist > profile.range:
		print("Out of range (%.0f / %.0f)" % [dist, profile.range])
		return

	var result: CombatResult = resolver.resolve_attack(player.stats, mob.stats, profile)
	print("%s | %s" % [profile.display_name, result.summary()])

	# --- Toy fun layer: immediate feedback ---
	if result.hit:
		mob.flash_hit()
		if result.crit:
			_spawn_floating_text(mob.global_position + Vector2(0, -24), str(-result.damage), "crit")
		else:
			_spawn_floating_text(mob.global_position + Vector2(0, -24), str(-result.damage), "hit")
	else:
		_spawn_floating_text(mob.global_position + Vector2(0, -24), "MISS", "miss")

	if mob.is_dead():
		_on_mob_killed()

func _on_mob_killed() -> void:
	var award: int = 5 + mob.stats.level * 2
	xp += award
	print("Gained XP: %d (Total: %d / %d)" % [award, xp, xp_to_next])

	while xp >= xp_to_next:
		xp -= xp_to_next
		_level_up()

	_respawn_mob()

func _level_up() -> void:
	player.stats.level += 1
	player.stats.max_hp += 8
	player.stats.hp = player.stats.max_hp
	player.stats.attack += 2
	player.stats.defense += 1
	player.stats.accuracy += 1

	xp_to_next = int(round(float(xp_to_next) * 1.35))
	print("LEVEL UP! Now level %d. Next XP: %d" % [player.stats.level, xp_to_next])

func _respawn_mob() -> void:
	mob.stats.hp = mob.stats.max_hp
	mob.global_position = Vector2(700, 350)
	print("Mob respawned.")

func drop_item_from_player(item_id: String, amount: int = 1) -> void:
	if player == null:
		return
	if player.inventory.get_count(item_id) < amount:
		return

	var item: ItemDef = player.inventory.defs.get(item_id, null)
	if item == null:
		return

	if not player.inventory.remove(item_id, amount):
		return

	var pickup_scene := preload("res://scenes/Pickup.tscn")
	var p = pickup_scene.instantiate()
	p.item = item
	p.amount = amount
	p.global_position = player.global_position + Vector2(32, 0)
	add_child(p)

	print("Dropped:", item.display_name, "x", amount)

func _draw() -> void:
	if player == null:
		return

	var profile: AttackProfile = player.get_attack()
	if profile == null:
		return

	draw_circle(
		to_local(player.global_position),
		profile.range,
		Color(1, 0, 0, 0.2)
	)

func _spawn_floating_text(world_pos: Vector2, msg: String, kind: String) -> void:
	if FloatingTextScene == null:
		return
	var ft = FloatingTextScene.instantiate()
	_vfx_parent.add_child(ft)
	ft.global_position = world_pos
	ft.popup(msg, kind)
