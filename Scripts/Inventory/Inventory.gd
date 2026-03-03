class_name Inventory
extends Node

class ItemSlot:
	var Item: BaseItemData
	var quantity : int

signal UpdatedInventory
signal UpdatedSlot (Slot : ItemSlot)

var Item_Slots : Array[ItemSlot]

@export var Inventory_Size : int = 12
@export var Start_Items : Dictionary[BaseItemData, int]

func _ready():
	#Create Slots
	for i in range(Inventory_Size):
		Item_Slots.append(ItemSlot.new())
	#Add Start Items
	for key in Start_Items:
		for i in range(Start_Items[key]):
			add_item(key)

#adds an item to inventory
func add_item (Item : BaseItemData) -> bool:
	var Slot : ItemSlot = get_item_slot(Item) #Searches for a slot containing item already
	
	if Slot and Slot.quantity < Item.Max_Stack_Size: #If found, increase slot item amount by 1.
		Slot.quantity += 1
	else:
		Slot = get_empty_item_slot() #If not found, get a new Slot to use
		
		if not Slot: #If no Slot, then cancel
			return false
		
		Slot.Item = Item #Adds the item to slot
		Slot.quantity = 1
	
	UpdatedInventory.emit()
	UpdatedSlot.emit(Slot)
	
	return true

#removes item from inventory
func remove_item (Item : BaseItemData):
	if not has_item(Item):
		return
	
	var Slot : ItemSlot = get_item_slot(Item)
	remove_item_from_slot(Slot)

#removes a item from a slot stack
func remove_item_from_slot (Slot : ItemSlot):
	if not Slot.Item:
		return
	
	if Slot.quantity == 1:
		Slot.Item = null
	else:
		Slot.quantity -=1
	
	UpdatedInventory.emit()
	UpdatedSlot.emit(Slot)

#retruns an item slot containing the specific item for stacking items
func get_item_slot(Item: BaseItemData) -> ItemSlot:
	for Slot in Item_Slots:
		# Check if it's the right item AND if it's not full
		if Slot.Item == Item and Slot.quantity < Item.Max_Stack_Size:
			return Slot

	return null

# returns a item slot with no items for storing new items
func get_empty_item_slot () -> ItemSlot:
	for Slot in Item_Slots:
		if Slot.Item == null:
			return Slot
	
	return null

# checks if item is in inventory
func has_item (Item : BaseItemData) -> bool:
	for Slot in Item_Slots:
		if Slot.Item == Item:
			return true
	
	return false
