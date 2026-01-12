# scripts/combat/attack_profile.gd
class_name AttackProfile
extends Resource

@export var display_name: String = "Melee"
@export var attack_range: float = 80.0

# Balance knobs
@export var damage_multiplier: float = 1.0
@export var accuracy_bonus: float = 0.0

#Later: cooldown, cast time, projectile, etc.
@export var cooldown: float = 0.0
