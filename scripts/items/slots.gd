# scripts/items/slots.gd
class_name EquipSlot
extends RefCounted

enum Slot {
	HEAD,
	CHEST,
	PANTS,
	GLOVES,
	BOOTS,

	EARRING_L,
	EARRING_R,
	NECKLACE,
	RING_L,
	RING_R,

	WEAPON,
	OFFHAND
}
static func slot_name(slot: int) -> String:
	return Slot.keys()[slot]
