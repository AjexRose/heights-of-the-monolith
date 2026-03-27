class_name DodgeController
extends Node2D

@onready var player : Player = $".."

#ProgressBars
@onready var InDodge_ProgressBar : ProgressBar = $InDodge_ProgressBar
@onready var DodgeRecharge_ProgressBar: ProgressBar = $DodgeRecharge_ProgressBar
#Timers
@onready var InDodgeTimer : Timer = $InDodge_ProgressBar/In_Dodge_Timer
@onready var DodgeRechargeTimer : Timer = $DodgeRecharge_ProgressBar/Dodge_Recharge_Timer

func _ready():
	InDodgeTimer.wait_time = player.In_Dodge_Time
	DodgeRechargeTimer.wait_time = player.Dodge_Recharge_Time
	
	InDodge_ProgressBar.max_value = InDodgeTimer.wait_time
	DodgeRecharge_ProgressBar.max_value = DodgeRechargeTimer.wait_time

func _process(delta: float):
	if player.Is_Shield_Down:
		player.Is_Shield_Down = false 
		_force_dodge()
		
	if Input.is_action_just_pressed("Dash") and player.Can_Dodge:
		_try_dodge()

	InDodge_ProgressBar.value = InDodgeTimer.time_left
	DodgeRecharge_ProgressBar.value = DodgeRechargeTimer.wait_time - DodgeRechargeTimer.time_left

func _try_dodge():
	player.Can_Dodge = false
	_dodge()

func _force_dodge():
	player.Can_Dodge = false
	_dodge()

func _dodge():
	InDodgeTimer.stop() #These stop timers already going to prevent unintended stacking
	DodgeRechargeTimer.stop() # <- see above
	
	player.Can_Take_Damage = false
	player.Current_Movement_Speed = player.Base_Movement_Speed * player.Dodge_Speed_Multi
	
	InDodge_ProgressBar.show()
	InDodgeTimer.start()

func _dodge_recharge():
	player.Current_Movement_Speed = player.Base_Movement_Speed
	player.Can_Take_Damage = true
	InDodge_ProgressBar.hide()
	
	DodgeRecharge_ProgressBar.show()
	DodgeRechargeTimer.start()

func _dodge_system_finish():
	DodgeRecharge_ProgressBar.hide()
	player.Can_Dodge = true
	player.Can_Take_Damage = true 
