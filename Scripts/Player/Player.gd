class_name Player
extends CharacterBody2D

# Upgradable Player Variables
@export var Max_Health : float = 10
@export var Max_Shield : float = 5
@export var Movement_Speed : float = 100
@export var Dodge_Amount: float = 1
@export var Dodge_Damage_Immune_Time: float = .3
#@export var Inventory_Max_Size: int = 10
#Non-Upgradable Player Variables
var Current_Health : float = 10
var Current_Shield : float = 5
var Can_Dodge: bool = true
var Can_Take_Damage: bool = true
# Non-Upgradable Weapon Variables
var Last_Shoot_Time: float
var Projectile_Entity: PackedScene = preload("res://Entities/Projectiles/base_bullet.tscn")
var Can_Fire: bool = true
var Bullet_Amount: float = 6
#Upgradable Weapon Variables
@export var Bullet_Capacity: float = 6
@export var Bullet_Per_Shot: float = 1
@export var Fire_Rate : float = 0.1
@export var Fire_Degree_Offset_Min : float = 0.8
@export var Fire_Degree_Offset_Max : float = 1.2
@export var Fire_Accuracy : float = 1
@export var Reload_Time : float = 2
# Component Variables
@onready var Player_Sprite : Sprite2D = $Player_Sprite2D
@onready var Weapon_Sprite : Sprite2D = $Weapon/Weapon_Sprite
@onready var Weapon_Origin : Node2D = $Weapon
@onready var Muzzle : Node2D = $Weapon/Bullet_Marker
@onready var ReloadTime : Timer = $Weapon/Reload_Timer
@onready var Reload_ProgressBar : ProgressBar = $Reload_ProgressBar
@onready var Player_Inventory : Node2D = $Inventory
@onready var Player_HUD : CanvasLayer = $HUD
@onready var Player_Inventory_HUD : Panel = $HUD/Inventory
@onready var Audio_Player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var Shoot_Audio = preload ("res://Audio/PROTO_gunshot.wav")

func _physics_process(delta):
	var move_input: Vector2 = Input.get_vector("Move_Left","Move_Right","Move_Up","Move_Down")
	velocity = move_input * Movement_Speed
	move_and_slide()

func _process(delta):
	var mouse_pos : Vector2 = get_global_mouse_position()
	var mouse_dir: Vector2 = (mouse_pos - global_position).normalized()
	Weapon_Origin.rotation_degrees = rad_to_deg(mouse_dir.angle())+90
	
	Player_Sprite.flip_h = mouse_dir.x < 0
	Weapon_Sprite.flip_v = mouse_dir.x < 0
	
	$Weapon/Reload_Timer.wait_time = Reload_Time
	$Reload_ProgressBar.max_value = $Weapon/Reload_Timer.wait_time
	$Reload_ProgressBar.value = $Weapon/Reload_Timer.wait_time - $Weapon/Reload_Timer.time_left
	
	if Bullet_Amount == 0:
		_Reload_Gun_Auto()
	
	if Input.is_action_just_pressed("Attack"):
		if Time.get_unix_time_from_system() - Last_Shoot_Time > Fire_Rate:
			_Shoot()
	if Input.is_action_just_pressed("Reload"):
		_Reload_Gun_Manual()
		print(Bullet_Amount)
	if Input.is_action_just_pressed("Interact_Inventory"):
		_Show_Inventory()

func _Shoot():
	if Can_Fire == true:
		for i in range(Bullet_Per_Shot):
			Last_Shoot_Time = Time.get_unix_time_from_system()
	
			var proj = Projectile_Entity.instantiate()
			get_tree().root.add_child(proj)
			proj.global_position = Muzzle.global_position
			proj.rotation = Weapon_Origin.rotation * randf_range(Fire_Degree_Offset_Max, Fire_Degree_Offset_Min)
			proj.Owner_Character = self
			Audio_Player.stream = Shoot_Audio
			Audio_Player.play()
		
		Bullet_Amount -= 1
		print(Bullet_Amount)
	elif Can_Fire == false:
		pass

func _Reload_Gun_Auto(): # This code runs if the gun is out of ammo automatically
	if Bullet_Amount == 0:
		if $Weapon/Reload_Timer.is_stopped(): #Makes sure you can't restart the reload while it's still going
			Can_Fire = false
			$Weapon/Reload_Timer.start()
			Reload_ProgressBar.visible = true
			$Reload_ProgressBar.value = $Weapon/Reload_Timer.wait_time - $Weapon/Reload_Timer.time_left

func _Reload_Gun_Manual(): #This code runs if the gun is reloaded via the Reload key
	if Bullet_Amount == Bullet_Capacity: #This makes sure you can't reload with a full cylinder
		return
	if $Weapon/Reload_Timer.is_stopped(): #Makes sure you can't restart the reload while it's still going
		Can_Fire = false
		$Weapon/Reload_Timer.start()
		Reload_ProgressBar.visible = true
		$Reload_ProgressBar.value = $Weapon/Reload_Timer.wait_time - $Weapon/Reload_Timer.time_left
# theres prob a way to combine the two funcs, but we ball
func _on_reload_timer_timeout():
	Bullet_Amount = Bullet_Capacity
	$Weapon/Reload_Timer.stop()
	Can_Fire = true
	Reload_ProgressBar.visible = false
	print(Bullet_Amount)

func _Show_Inventory():
	if $HUD/Inventory.visible == false:
		$HUD/Inventory.visible = true
	else:
		$HUD/Inventory.visible = false

func take_damage (amount: float):
	pass
	
