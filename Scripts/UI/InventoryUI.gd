class_name InventoryUI
extends Panel

@export var slots : Array[InventorySlotUI]
@onready var inventory : Inventory = $"../../Inventory"
@onready var player : Player = $"../.."

@onready var info_panel : Panel = $"../Item_Info_Panel"
@onready var info_panel_name : Label = $"../Item_Info_Panel/Item_Name"
@onready var info_panel_description : Label = $"../Item_Info_Panel/Item_Description"

func _ready () : 
	inventory.UpdatedInventory.connect(_update_ui)

	_update_ui()
	_hide_info_panel()
	
	for slot in slots:
		slot.mouse_entered.connect(func():_set_info_panel(slot))
		slot.mouse_exited.connect(_hide_info_panel)

func _process (delta : float):
	if not info_panel.visible:
		return
		
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	info_panel.global_position = mouse_pos - Vector2(0, info_panel.size.y)

func _update_ui ():
	for i in len(slots):
		slots[i].set_item_slot(inventory.Item_Slots[i], player)

func _set_info_panel (slot : InventorySlotUI):
	var item = slot.item_slot.Item
	
	if not item:
		return
	
	info_panel.visible = true
	info_panel_name.text = item.Display_Name
	info_panel_description.text = item.Description

func _hide_info_panel ():
	info_panel.visible = false
