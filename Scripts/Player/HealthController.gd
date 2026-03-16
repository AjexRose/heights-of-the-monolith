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

func take_damage (amount: int):

	if player.Current_Shield > 0:
		player.Current_Shield -= amount
		shield_damage_flash()
		
		if player.Current_Shield <= 0 and not player.Is_Shield_Down:
			player.Current_Shield = 0
			shield_down_()
		amount = 0
	
	if player.Is_Shield_Down and amount > 0:
		player.Current_Health -= amount
		health_damage_flash()
	
func shield_down_ ():
	if player.Is_Shield_Down == false:
		player.Dodge_Controller._force_dodge()
		player.Is_Shield_Down = true
		return
	
func shield_up():
	if player.Is_Shield_Down == true:
		if player.Current_Shield > 0:
			player.Is_Shield_Down = false
			
func shield_damage_flash():
	player.Player_Sprite.modulate = Color.MEDIUM_TURQUOISE
	await get_tree().create_timer(0.1).timeout
	player.Player_Sprite.modulate = Color.WHITE

func health_damage_flash():
	player.Player_Sprite.modulate = Color.DARK_RED
	await get_tree().create_timer(0.1).timeout
	player.Player_Sprite.modulate = Color.WHITE
