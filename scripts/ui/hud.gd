# scripts/ui/hud.gd
extends CanvasLayer

@export var player_path: NodePath
@export var mob_path: NodePath
@export var arena_path: NodePath

@onready var combat_log: CombatLog = $Panel/CombatLog

@onready var _player := get_node_or_null(player_path)
@onready var _mob := get_node_or_null(mob_path)
@onready var _arena := get_node_or_null(arena_path)

@onready var lbl_player := %PlayerLabel
@onready var lbl_mob := %MobLabel
@onready var lbl_xp := %XpLabel
@onready var lbl_mode := %ModeLabel
@onready var lbl_weight := %WeightLabel

func _ready() -> void:
	# If someone duplicates the scene and forgets to wire NodePaths, don't crash.
	set_process(true)

func _process(_delta: float) -> void:
	# Lazy re-bind if scene got reloaded
	if _player == null and player_path != NodePath():
		_player = get_node_or_null(player_path)
	if _mob == null and mob_path != NodePath():
		_mob = get_node_or_null(mob_path)
	if _arena == null and arena_path != NodePath():
		_arena = get_node_or_null(arena_path)

	if _player != null and _player.stats != null:
		lbl_player.text = "Player L%d  HP %d/%d  ATK %d  DEF %d" % [
			_player.stats.level, _player.stats.hp, _player.stats.max_hp,
			_player.stats.attack, _player.stats.defense
		]
		if "inventory" in _player:
			var w = _player.inventory.total_weight()
			var max_w = _player.max_weight
			lbl_weight.text = "Weight %.1f / %.1f" % [w, max_w]
	else:
		lbl_player.text = "Player: (not wired)"
		lbl_weight.text = ""

	if _mob != null and _mob.stats != null:
		lbl_mob.text = "Mob L%d  HP %d/%d  ATK %d  DEF %d" % [
			_mob.stats.level, _mob.stats.hp, _mob.stats.max_hp,
			_mob.stats.attack, _mob.stats.defense
		]
	else:
		lbl_mob.text = "Mob: (not wired)"

	if _arena != null:
		if "xp" in _arena and "xp_to_next" in _arena:
			lbl_xp.text = "XP %d / %d" % [_arena.xp, _arena.xp_to_next]
	else:
		lbl_xp.text = ""

	if _player != null and "get_attack" in _player:
		var a = _player.get_attack()
		lbl_mode.text = "Mode: %s (1/2 to swap)" % (a.display_name if a != null else "None")
	else:
		lbl_mode.text = ""
