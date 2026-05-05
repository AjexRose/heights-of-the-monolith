class_name PlayerCamera
extends Camera2D

@export var target : Player

var shake_intensity: float = 0.0
var active_shake_time: float = 0.0

var shake_decay: float = 5.0

var shake_time: float = 0.0
var shake_time_speed: float = 20.0

var noise = FastNoiseLite.new()

func _ready():
	if GameManager.camera and GameManager.camera != self:
		queue_free()
		return
	GameManager.camera = self
	
	if get_parent() != get_tree().root:
		reparent.call_deferred(get_tree().root)

func _physics_process(delta):
	# Fallback if target is lost
	if not target and GameManager.player:
		target = GameManager.player
		
	if target:
		global_position = global_position.lerp(target.global_position, delta * 5.0)
		
	#screen shake tech
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed	
		active_shake_time -= delta
		
		offset = Vector2(
			noise.get_noise_2d(shake_time, 0)*shake_intensity,
			noise.get_noise_2d(shake_time, 0)*shake_intensity
		)
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func screen_shake(intensity: int, time: float):
	randomize()
	noise.seed=randi()
	noise.frequency=2.0
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0

func force_snap():
	if target:
		global_position = target.global_position
		reset_smoothing()
	make_current()
