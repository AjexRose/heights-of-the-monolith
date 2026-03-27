class_name HealthController
extends Node2D

@onready var player : Player = $".."

@onready var Shield_Break_Immune_Timer : Timer = $ShieldBreakImmuneTimer

func _process(delta: float):
	Shield_Break_Immune_Timer.wait_time = player.Shield_Break_Immune_Time

func heal_health(amount : float):
	player.Current_Health += amount
	if player.Current_Health > player.Max_Health:
		player.Current_Health = player.Max_Health

func heal_shield(amount : float):
	player.Current_Shield += amount
	if player.Current_Shield > player.Max_Shield:
		player.Current_Shield = player.Max_Shield

func take_damage(amount: int):
	#SHIELD SYSTEM
	if player.Current_Shield > 0:
		player.Current_Shield -= amount
		shield_damage_flash()
		
		if player.Current_Shield <= 0:
			player.Current_Shield = 0
			shield_down_() # <- Auto-Dodge connection

	# HEALTH SYSTEM: 
	if player.Current_Shield <= 0:
		if not player.Can_Take_Damage: #checks if in dodge
			return
		player.Current_Health -= amount
		health_damage_flash()
	
func shield_down_ ():
	if not player.Is_Shield_Down:
		player.Is_Shield_Down = true
		player.Dodge_Controller._force_dodge() 
		# trigger the animation here
	
func shield_up():
	if player.Is_Shield_Down == true:
		if player.Current_Shield > 0:
			player.Is_Shield_Down = false
			# trigger the animation here
			
func shield_damage_flash():
	player.Player_Sprite.modulate = Color.MEDIUM_TURQUOISE
	await get_tree().create_timer(0.1).timeout
	player.Player_Sprite.modulate = Color.WHITE

func health_damage_flash():
	player.Player_Sprite.modulate = Color.DARK_RED
	await get_tree().create_timer(0.1).timeout
	player.Player_Sprite.modulate = Color.WHITE
