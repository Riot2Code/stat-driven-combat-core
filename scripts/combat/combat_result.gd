# scripts/combat_result.gd
class_name CombatResult
extends RefCounted

# A simple data container returned by CombatResolver.

var attacker_name: String
var defender_name: String

var hit: bool = false
var crit: bool = false
var damage: int = 0

var defender_hp_before: int = 0
var defender_hp_after: int = 0

func summary() -> String:
	if not hit:
		return "%s -> %s : MISS (HP %d)" % [attacker_name, defender_name, defender_hp_after]
	var crit_txt := " CRIT" if crit else ""
	return "%s -> %s : HIT%s for %d (HP %d -> %d)" % [
		attacker_name, defender_name, crit_txt, damage, defender_hp_before, defender_hp_after
	]
