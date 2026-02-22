class_name InventorySlotUI
extends GameButton

@onready var Item_Icon : TextureRect = $Item_Icon
@onready var Item_Quantity_Text : Label = $Item_Quantity_Text
@onready var WeaponMod : TextureRect = $Weapon_Equip_Background

var item_slot : Inventory.ItemSlot
var player : Player

func set_item_slot (item_slot : Inventory.ItemSlot, player : Player):
	self.item_slot = item_slot
	self.player = player
	
	var is_equipped : bool = false
	
	#Change is equipped if a item is equiped
	
	WeaponMod.visible = is_equipped
	
	#sets icon
	if item_slot.Item:
		Item_Icon.texture = item_slot.Item.Icon
	else:
		Item_Icon.texture = null
		Item_Quantity_Text.text = ""
		return
	#Set quantity text
	if item_slot.quantity > 1:
		Item_Quantity_Text.text = str(item_slot.quantity)
	else:
		Item_Quantity_Text.text = ""
	
func _on_pressed ():
	super._on_pressed()
	
	if not item_slot or not item_slot.item:
		return
	
	#pass
	#click on the item - trigger it's effect
