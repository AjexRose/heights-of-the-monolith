extends Camera2D

@export var target : Player

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

func force_snap():
	if target:
		global_position = target.global_position
		reset_smoothing()
	make_current()
