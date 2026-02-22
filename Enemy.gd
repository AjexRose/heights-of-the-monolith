extends CharacterBody2D

@export var Current_HP : int = 4
@export var Max_HP : int = 4
@export var Movement_Speed : float = 60

@export var Attack_Damage : int = 1
@export var Attack_Range : float = 10
@export var Attack_Rate : float = 0.5
var Last_Attack_Time : float

@onready var Enemy_Sprite: Sprite2D = $Sprite2D
@onready var Audio_Player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var Damage_Audio = preload ('res://Audio/PROTO_hurt_noise.wav')
@onready var Death_Audio = preload ('res://Audio/PROTO_die_noise.wav')

var Is_Active : bool = false
var Player : CharacterBody2D

var Player_Direction : Vector2
var Player_Distance : float

func _ready():
	Player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	Player_Direction = global_position.direction_to(Player.global_position)
	Player_Distance = global_position.distance_to(Player.global_position)
	
	Enemy_Sprite.flip_h = Player_Direction.x < 0
	
	velocity = Player_Direction * Movement_Speed
	
	move_and_slide()

func take_damage (amount : int):
	Current_HP -= amount
	Audio_Player.stream = Damage_Audio
	Audio_Player.play()
	
	if Current_HP <= 0:
		die()
	
func die ():
	Audio_Player.stream = Death_Audio
	Audio_Player.play()
	queue_free()
