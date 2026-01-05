# scripts/stats.gd
class_name Stats
extends Resource

@export var name: String = "Entity"

@export var level: int = 1
@export var max_hp: int = 100
@export var hp: int = 100

@export var attack: int = 10
@export var defense: int = 5

@export var accuracy: int = 75    # 0-100 baseline
@export var evasion: int = 15     # 0-100 baseline

@export var crit_chance: float = 0.05      # 0.0 - 1.0
@export var crit_multiplier: float = 1.5   # 1.0+

func clamp_hp() -> void:
	hp = clamp(hp, 0, max_hp)

func is_dead() -> bool:
	return hp <= 0
