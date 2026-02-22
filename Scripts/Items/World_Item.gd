class_name WorldItem
extends Area2D

var Item : BaseItemData

@onready var ItemSprite : Sprite2D = $ItemSprite

var Bob_Speed : float = 4
var Bob_Amount : float = 2

@export var TESTITEM : BaseItemData

func _ready():
	set_item(TESTITEM)

func _process (delta : float):
	#Item Bobbing up and down
	var Time : float = Time.get_unix_time_from_system()
	var Offset : float = sin(Time*Bob_Speed)*Bob_Amount
	ItemSprite.position.y = Offset

func set_item (Item: BaseItemData):
	self.Item = Item
	ItemSprite.texture = Item.Icon

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	
	var picked_up = body.Player_Inventory.add_item(Item)
	
	if not picked_up:
		return
		
	queue_free()
