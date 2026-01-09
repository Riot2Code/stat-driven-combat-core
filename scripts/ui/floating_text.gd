# scripts/ui/floating_text.gd
class_name FloatingText
extends Label

@export var rise_px: float = 48.0
@export var duration: float = 0.65
@export var spread_px: float = 18.0
@export var font_size := 18

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	# Small readability defaults
	add_theme_font_size_override("font_size", font_size)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	z_index = 50

func popup(msg: String, kind: String = "hit") -> void:
	text = msg

	# Simple styling by kind (keep it readable, not fancy)
	match kind:
		"miss":
			modulate = Color(0.9, 0.9, 0.9, 1.0)
		"crit":
			modulate = Color(1.0, 0.95, 0.35, 1.0)
		"hit":
			modulate = Color(1.0, 1.0, 1.0, 1.0)
		_:
			modulate = Color(1.0, 1.0, 1.0, 1.0)

	# Randomize a tiny bit so repeated hits don't stack perfectly
	position += Vector2(_rng.randf_range(-spread_px, spread_px), _rng.randf_range(-spread_px * 0.25, spread_px * 0.25))

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(0, -rise_px), duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.finished.connect(queue_free)
