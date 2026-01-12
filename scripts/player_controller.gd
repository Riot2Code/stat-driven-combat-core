# scripts/player_controller.gd
class_name PlayerController
extends Actor

@export var move_speed: float = 220.0

# Targeting system
@onready var targeting: Targeting = $Targeting

# Weight system
@export var max_weight: float = 300.0
var inventory: Inventory = Inventory.new()
var equipment: Equipment = Equipment.new()

# Debug start items (drag .tres ItemDef resources here)
@export var debug_iron_helmet: ItemDef
@export var debug_ring: ItemDef
@export var debug_sword: ItemDef

# Attack modes (drag AttackProfile .tres files into this array)
@export var attacks: Array[AttackProfile] = []
var attack_index: int = 0


func _ready() -> void:
	super._ready()

	# TEMP: seed inventory so you can test weight/penalties immediately.
	# You can delete this later once drops/vendors exist.
	if debug_iron_helmet != null:
		inventory.add(debug_iron_helmet, 1)
	if debug_ring != null:
		inventory.add(debug_ring, 2)
	if debug_sword != null:
		inventory.add(debug_sword, 1)

	print("Weight:", snappedf(inventory.total_weight(), 0.1), "/", max_weight)

func get_attack() -> AttackProfile:
	if attacks.is_empty():
		return null
	return attacks[clampi(attack_index, 0, attacks.size() - 1)]

func set_attack_index(i: int) -> void:
	if attacks.is_empty():
		return
	attack_index = clampi(i, 0, attacks.size() - 1)
	var a := get_attack()
	if a != null:
		print("Attack mode:", a.display_name)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#print("CLICK:", get_global_mouse_position())
		var clicked := _pick_target_at_mouse()
		if clicked:
			targeting.set_target(clicked)
		else:
			targeting.clear_target()

func _physics_process(_delta: float) -> void:
	var ratio: float = 0.0
	if is_dead():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if max_weight > 0.0:
		ratio = inventory.total_weight() / max_weight

	var penalty_mult: float = _weight_multiplier(ratio)

	var input := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	velocity = input * move_speed * penalty_mult
	move_and_slide()

func _weight_multiplier(ratio: float) -> float:
	if ratio <= 0.5:
		return 1.0
	if ratio <= 0.8:
		return 0.85
	if ratio <= 1.0:
		return 0.65
	return 0.35

#Helper
func _pick_target_at_mouse() -> Node:
	var space := get_world_2d().direct_space_state
	var pos := get_global_mouse_position()

	var params := PhysicsPointQueryParameters2D.new()
	params.position = pos
	params.collide_with_areas = true
	params.collide_with_bodies = true

	var hits := space.intersect_point(params, 16)
	#print("HITS:", hits.size())

	for h in hits:
		var c = h.get("collider")
		#print("COLLIDER:", c, " groups:", c.get_groups())
		if c and c.is_in_group("targetable"):
			# If you clicked a child collider, walk up until the grouped parent
			var n: Node = c
			while n and not n.is_in_group("targetable"):
				n = n.get_parent()
			return n if n else c

	return null
