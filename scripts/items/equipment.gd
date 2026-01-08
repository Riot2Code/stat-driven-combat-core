# scripts/items/equipment.gd
class_name Equipment
extends RefCounted

# Slot -> item_id (or "" for empty)
var slots: Dictionary = {}

func _init() -> void:
	# Initialize all slots empty
	for s in EquipSlot.Slot.values():
		slots[s] = ""
		
func get_item_id(slot: int) -> String:
	return String(slots.get(slot, ""))

func equip(slot: int, item_id: String) -> void:
	slots[slot] = item_id
	
func unequip(slot: int) -> String:
	var prev := get_item_id(slot)
	slots[slot] = ""
	return prev

func is_empty(slot: int) -> bool:
	return get_item_id(slot) == ""
