extends Node2D

@export var Current_HP : int = 2
@export var Can_Drop_Items : bool = false
@export var Max_Item_Drops : int = 0
@export var Drop_Pool : Dictionary [BaseItemData, int]

@onready var Damagable_Sprite: Sprite2D = $Damagable_Crate_Icon
@onready var Audio_Player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var Damage_Audio = preload ('res://Audio/PROTO_hurt_noise.wav')
@onready var Death_Audio = preload ('res://Audio/PROTO_die_noise.wav')

var World_Item_Scene : PackedScene = preload("res://Entities/Items/world_item.tscn")

func take_damage(amount : int):
	Current_HP -= amount
	Audio_Player.stream = Damage_Audio
	Audio_Player.play()
	damage_flash()
	
	if Current_HP <= 0:
		Audio_Player.stream = Death_Audio
		Audio_Player.play()
		_destroy_damagable()

func damage_flash():
	Damagable_Sprite.modulate = Color.BLACK
	await get_tree().create_timer(0.1).timeout
	Damagable_Sprite.modulate = Color.WHITE

func _destroy_damagable():
	_drop_item()
	queue_free()

func _drop_item():
	var item_data : BaseItemData = _get_item_to_drop()
	var world_item : WorldItem = World_Item_Scene.instantiate()
	
	get_parent().add_child.call_deferred(world_item)
	world_item.global_position = global_position
	
	world_item.set_item(item_data)
	
func _get_item_to_drop() -> BaseItemData:
	var total_weight : int = 0
	
	for key in Drop_Pool:
		total_weight += Drop_Pool[key]
		
	var rand : int = randi_range(0, total_weight)
	var count : int = 0
	
	for key in Drop_Pool:
		count+= Drop_Pool[key]
		
		if rand <= count : 
			return key
			
	return null
