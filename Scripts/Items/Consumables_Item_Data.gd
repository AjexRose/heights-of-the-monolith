class_name ConsumablesItemData
extends BaseItemData

@export var IsHealthConsumable : bool = false
@export var Health_Restored : float = 0
@export var IsShieldConsumable : bool = false
@export var Shield_Restored : float = 0
@export var Movement_Speed_Up_Percent: float = 0

func _select_in_inventory(player : Player, item_slot : Inventory.ItemSlot):
	if IsHealthConsumable == true:
		if player.Current_Health != player.Max_Health:
			player.Health_Controller.heal_health(Health_Restored)
			player.Player_Inventory.remove_item_from_slot(item_slot)
		else:
			return
	if IsShieldConsumable == true:
		if player.Current_Shield != player.Max_Shield:
			player.Health_Controller.heal_shield(Shield_Restored)
			player.Player_Inventory .remove_item_from_slot(item_slot)
		else:
			return
