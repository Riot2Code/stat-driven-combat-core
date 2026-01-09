# scripts/actor.gd
class_name Actor
extends CharacterBody2D

@export var stats: Stats

func _ready() -> void:
	if stats == null:
		stats = Stats.new()
		stats.name = name

func is_dead() -> bool:
	return stats.is_dead()

func flash_hit(duration: float = 0.08) -> void:
	# Assumes a child ColorRect named 'ColorRect' (matches current scenes).
	var rect := get_node_or_null("ColorRect")
	if rect == null:
		return
	var old = rect.modulate
	rect.modulate = Color(1, 0.35, 0.35, 1)
	var t := create_tween()
	t.tween_property(rect, "modulate", old, duration)
