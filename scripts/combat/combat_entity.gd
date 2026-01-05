# scripts/combat_entity.gd
class_name CombatEntity
extends Node2D

@export var stats: Stats

func _ready() -> void:
	if stats == null:
		stats = Stats.new()
		stats.name = name

func is_dead() -> bool:
	return stats.is_dead()
