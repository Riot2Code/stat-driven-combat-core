# scripts/items/inventory.gd
class_name Inventory
extends RefCounted

# Map item_id -> count
var counts: Dictionary = {} # String -> int
# Map item_id -> ItemDef (definitions you've encountered)
var defs: Dictionary = {}   # String -> ItemDef

func add(item: ItemDef, amount: int = 1) -> void:
	if amount <= 0:
		return
	defs[item.item_id] = item
	counts[item.item_id] = int(counts.get(item.item_id, 0)) + amount

func remove(item_id: String, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	if not counts.has(item_id):
		return false

	var c: int = int(counts[item_id])
	if c < amount:
		return false

	c -= amount
	if c <= 0:
		counts.erase(item_id)
	else:
		counts[item_id] = c
	return true

func get_count(item_id: String) -> int:
	return int(counts.get(item_id, 0))

func total_weight() -> float:
	var w: float = 0.0
	for item_id in counts.keys():
		var item: ItemDef = defs.get(item_id, null)
		if item == null:
			continue
		w += float(counts[item_id]) * item.weight
	return w
