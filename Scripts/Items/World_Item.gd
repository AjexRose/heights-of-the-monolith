class_name WorldItem
extends Interactable

var Item : BaseItemData

var ItemSprite : Sprite2D
var sound_emitter : AudioStreamPlayer2D

@export var pickup_sound : AudioStreamWAV

var Bob_Speed : float = 4
var Bob_Amount : float = 2

func _ready():
	ItemSprite = get_node_or_null("ItemSprite")
	sound_emitter = get_node_or_null("AudioStreamPlayer2D")
	self.Interact.connect(_on_interact)

func _process (delta : float):
	var Time_Val : float = Time.get_unix_time_from_system()
	var Offset : float = sin(Time_Val * Bob_Speed) * Bob_Amount
	ItemSprite.position.y = Offset

func set_item (Item: BaseItemData):
	self.Item = Item
	$ItemSprite.texture = Item.Icon
	self.prompt = "Pick up " + Item.Display_Name
	self.can_interact = true

func _on_interact(player: Player):
	var picked_up = player.Player_Inventory.add_item(Item)
	
	if not picked_up:
		print("Inventory Full")
		return

	can_interact = false
	
	if ItemSprite:
		ItemSprite.hide()
		
	if sound_emitter and pickup_sound:
		sound_emitter.stream = pickup_sound
		sound_emitter.pitch_scale = randf_range(0.8, 1.2)
		sound_emitter.play()
		await sound_emitter.finished
	else:
		print("DEBUG: No sound emitter or sound file found.")

	queue_free()
