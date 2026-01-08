func can_equip(item: ItemDef, slot: int) -> bool:
	return item != null and item.equip_slots.has(slot)

func try_equip(inventory: Inventory, item_id: String, slot: int) -> bool:
	if inventory == null:
		return false

	if inventory.get_count(item_id) <= 0:
		return false

	var item: ItemDef = inventory.defs.get(item_id, null)
	if item == null:
		return false

	if not can_equip(item, slot):
		return false

	# remove one from inventory
	if not inventory.remove(item_id, 1):
		return false

	# swap out old item (if any) back to inventory
	var prev_id: String = get_item_id(slot)
	if prev_id != "":
		inventory.add(inventory.defs[prev_id], 1)

	# equip new
	equip(slot, item_id)
	return true

func try_unequip(inventory: Inventory, slot: int) -> bool:
	var item_id := get_item_id(slot)
	if item_id == "":
		return false

	var item: ItemDef = inventory.defs.get(item_id, null)
	if item == null:
		return false

	# clear slot and add back
	unequip(slot)
	inventory.add(item, 1)
	return true
