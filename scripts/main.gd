# scripts/main.gd
extends Node2D

@onready var resolver: CombatResolver = $CombatWorld/CombatResolver
@onready var player: CombatEntity = $Entities/Player
@onready var dummy: CombatEntity = $Entities/Dummy

func _ready() -> void:
	print("Ready. Press SPACE to attack the Dummy.")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if dummy.is_dead():
			print("Dummy is already dead.")
			return
		var result: CombatResult = resolver.resolve_basic_attack(player.stats, dummy.stats)
		print(result.summary())

	if event.is_action_pressed("reset_dummy"):
		dummy.stats.hp = dummy.stats.max_hp
		print("Dummy reset to full HP: %d" % dummy.stats.hp)
