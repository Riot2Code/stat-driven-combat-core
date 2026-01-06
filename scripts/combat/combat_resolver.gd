# scripts/combat_resolver.gd
class_name CombatResolver
extends Node

# "Authoritative" here means: all combat math lives in one place.
# Later, this becomes your server-side authority in multiplayer.

@export var rng_seed: int = 123456

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.seed = rng_seed

func resolve_basic_attack(attacker: Stats, defender: Stats) -> CombatResult:
	return resolve_attack(attacker, defender, null)
	var r: CombatResult = CombatResult.new()
	r.attacker_name = attacker.name
	r.defender_name = defender.name

	r.defender_hp_before = defender.hp

func resolve_attack(attacker: Stats, defender: Stats, profile: AttackProfile) -> CombatResult:
	var r: CombatResult = CombatResult.new()
	r.attacker_name = attacker.name
	r.defender_name = defender.name
	r.defender_hp_before = defender.hp

	var acc_bonus: float = 0.0
	var dmg_mult: float = 1.0
	if profile != null:
		acc_bonus = profile.accuracy_bonus
		dmg_mult = profile.damage_multiplier

	# ---- HIT CHECK (simple but robust) ----
	# Convert to an effective hit chance, clamped.
	# You can later expand this with level gaps, buffs, positioning, etc.
	var hit_chance := float(attacker.accuracy - defender.evasion)
	hit_chance = clampf(hit_chance, 5.0, 95.0) # Always some chance either way.

	var roll := _rng.randf_range(0.0, 100.0)
	r.hit = roll <= hit_chance

	if not r.hit:
		r.damage = 0
		r.defender_hp_after = defender.hp
		return r

	# ---- CRIT CHECK ----
	r.crit = _rng.randf() <= attacker.crit_chance

	# ---- DAMAGE ----
	var base_damage :int= maxi(attacker.attack - defender.defense, 1)
	var final_damage := float(base_damage) * dmg_mult
	if r.crit:
		final_damage *= attacker.crit_multiplier

	r.damage = int(round(final_damage))

	# Apply damage
	defender.hp -= r.damage
	defender.clamp_hp()

	r.defender_hp_after = defender.hp
	return r
