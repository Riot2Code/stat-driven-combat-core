# scripts/items/item_def.gd
class_name ItemDef
extends Resource

enum ItemType { ARMOR, JEWELRY, WEAPON, OFFHAND, CONSUMABLE, MISC }

@export var item_id: String = "item_unknown"
@export var display_name: String = "Unknown Item"
@export var type: ItemType = ItemType.MISC

# Weight system (L2-style)
@export var weight: float = 1.0
@export var stackable: bool = false

# If equippable, which slots it can go into
@export var equip_slots: Array[int] = [] # EquipSlot.Slot enums

# Later: stat modifiers (keep simple for now)
@export var bonus_attack: int = 0
@export var bonus_defense: int = 0
