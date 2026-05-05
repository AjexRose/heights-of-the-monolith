class_name HealthController
extends Node2D

@onready var player : Player = $".."
@onready var Shield_Break_Immune_Timer : Timer = $ShieldBreakImmuneTimer
@onready var Shield_Break_FX : PackedScene = preload ("res://Particles/ShieldDownFX.tscn")
@onready var Damage_Sound = preload ('res://Audio/PROTO_hurt_noise.wav')

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
		player.Audio_Player.stream = Damage_Sound
		player.Audio_Player.pitch_scale = randf_range(0.8, 1.2)
		player.Audio_Player.play()
		if GameManager.camera:
			GameManager.camera.screen_shake(1,0.1)
		
		if player.Current_Shield <= 0:
			player.Current_Shield = 0
			shield_down_() # <- Auto-Dodge connection
			player.Audio_Player.stream = Damage_Sound
			player.Audio_Player.play()
			if GameManager.camera:
				GameManager.camera.screen_shake(2,0.1)

	# HEALTH SYSTEM: 
	if player.Current_Shield <= 0:
		if not player.Can_Take_Damage: #checks if in dodge
			return
		player.Current_Health -= amount
		health_damage_flash()
		player.Audio_Player.stream = Damage_Sound
		player.Audio_Player.pitch_scale = randf_range(0.5, 1.5)
		player.Audio_Player.play()
		if GameManager.camera:
			GameManager.camera.screen_shake(2,0.3)
			if player.Current_Health >= 3:
				GameManager.camera.screen_shake(4,0.3)
		if player.Current_Health <= 0:
			player_death()
	
func shield_down_ ():
	if not player.Is_Shield_Down:
		player.Is_Shield_Down = true
		player.Dodge_Controller._force_dodge() 
		# trigger the animation here
		var sb_instance = Shield_Break_FX.instantiate()
		player.add_child(sb_instance)
		sb_instance.position = Vector2.ZERO 
		if sb_instance is GPUParticles2D or sb_instance is CPUParticles2D:
			sb_instance.emitting = true
		await get_tree().create_timer(sb_instance.lifetime).timeout
		sb_instance.queue_free()
	
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

func player_death():
	player.Can_Move = false
	player.Can_Use = false
	player.Can_Take_Damage = false
	player.Player_Sprite.hide()
	player.Weapon_Sprite.hide()
	player.GameOverScreen.show()
