extends CharacterBody2D

@export var Current_HP : int = 4
@export var Max_HP : int = 4
@export var Movement_Speed : float = 60

@export var Attack_Damage : int = 1
@export var Attack_Range : float = 10
@export var Attack_Rate : float = 1
var Last_Attack_Time : float

@onready var Enemy_Sprite: Sprite2D = $Sprite2D
@onready var Audio_Player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var Damage_Audio = preload ('res://Audio/PROTO_hurt_noise.wav')
@onready var Death_Audio = preload ('res://Audio/PROTO_die_noise.wav')

var Is_Active : bool = false
var player : CharacterBody2D

var Player_Direction : Vector2
var Player_Distance : float

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	Is_Active = true

func _physics_process(delta):
	
	if not Is_Active or not Player: 
		return
	
	Player_Direction = global_position.direction_to(player.global_position)
	Player_Distance = global_position.distance_to(player.global_position)
	
	Enemy_Sprite.flip_h = Player_Direction.x < 0
	
	if Player_Distance < Attack_Range:
		_try_attack()
		return
	
	velocity = Player_Direction * Movement_Speed
	
	move_and_slide()

func take_damage (amount : int):
	Current_HP -= amount
	Audio_Player.stream = Damage_Audio
	Audio_Player.play()
	damage_flash()
	
	if Current_HP <= 0:
		die()

func damage_flash():
	Enemy_Sprite.modulate = Color.DARK_RED
	await get_tree().create_timer(0.1).timeout
	Enemy_Sprite.modulate = Color.WHITE

func die ():
	Audio_Player.stream = Death_Audio
	Audio_Player.play()
	queue_free()

func _try_attack():
	if Time.get_unix_time_from_system() - Last_Attack_Time < Attack_Rate:
		return
	
	Last_Attack_Time = Time.get_unix_time_from_system()
	
	player.Health_Controller.take_damage(Attack_Damage)
