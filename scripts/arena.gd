extends Node2D

@export var player_path: NodePath
@export var mob_path: NodePath
@export var resolver_path: NodePath
@export var attack_range: float = 80.0

@onready var player: PlayerController = get_node_or_null(player_path)
@onready var mob: MobAI = get_node_or_null(mob_path)
@onready var resolver: CombatResolver = get_node_or_null(resolver_path)

var xp: int = 0
var xp_to_next: int = 10

func _ready() -> void:
	if player == null or mob == null or resolver == null:
		push_error("Arena wiring is missing. Check exported NodePaths on CombatWorld (arena.gd).")
		return

	mob.set_target(player)
	print("Arena ready. Kite and press SPACE to attack.")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if mob == null or resolver == null or player == null:
			push_error("Arena refs are null during attack. Check NodePaths.")
			return

		# ---- RANGE CHECK ----
		var dist: float = player.global_position.distance_to(mob.global_position)
		if dist > attack_range:
			print("Out of range (%.0f / %.0f)" % [dist, attack_range])
			return

		if mob.is_dead():
			print("Mob is dead.")
			return

		var result: CombatResult = resolver.resolve_basic_attack(player.stats, mob.stats)
		print(result.summary())

		if mob.is_dead():
			_on_mob_killed()

	if event.is_action_pressed("reset_dummy"):
		_respawn_mob()

func _draw() -> void:
	draw_circle(player.position, attack_range, Color(1, 0, 0, 0.2))

func _on_mob_killed() -> void:
	# Award XP (simple)
	var award := 5 + mob.stats.level * 2
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

	# Make next level a bit harder
	xp_to_next = int(round(float(xp_to_next) * 1.35))

	print("LEVEL UP! Now level %d. Next XP: %d" % [player.stats.level, xp_to_next])

func _respawn_mob() -> void:
	mob.stats.hp = mob.stats.max_hp
	mob.global_position = Vector2(700, 350) # pick a spot in your arena
	print("Mob respawned.")
