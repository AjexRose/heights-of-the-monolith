class_name WorldItem
extends Interactable

var Item : BaseItemData

@onready var ItemSprite : Sprite2D = $ItemSprite

var Bob_Speed : float = 4
var Bob_Amount : float = 2

func _ready():
	self.Interact.connect(_on_interact)

func _process (delta : float):
	var Time_Val : float = Time.get_unix_time_from_system()
	var Offset : float = sin(Time_Val * Bob_Speed) * Bob_Amount
	ItemSprite.position.y = Offset

func set_item (Item: BaseItemData):
	self.Item = Item
	$ItemSprite.texture = Item.Icon
	self.prompt = "Pick up " + Item.Display_Name
	self.can_interact = true # 

func _on_interact(player: Player):
	var picked_up = player.Player_Inventory.add_item(Item)
	
	if not picked_up:
		return
		
	queue_free()
