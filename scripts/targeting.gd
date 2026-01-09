# scripts/targeting.gd
class_name Targeting
extends Node

signal target_changed(new_target: Node)

var current_target: Node = null
func set_target(t: Node) -> void:
	if t == current_target:
		print("SET TARGET:", t)
		return

	_clear_highlight(current_target)
	current_target = t
	_apply_highlight(current_target)
	target_changed.emit(current_target)

func clear_target() -> void:
	set_target(null)
	
func _apply_highlight(t: Node) -> void:
	if t == null:
		return
	#simplest "works everywhere" highlight: modulate
	if t is CanvasItem:
		(t as CanvasItem).modulate = Color(1.25, 1.25, 1.25, 1.0) # brighter
		
func _clear_highlight(t: Node) -> void:
	if t == null:
		return
	if t is CanvasItem:
		(t as CanvasItem).modulate = Color(1, 1, 1, 1)
