extends Area2D

@export var Projectile_Speed : float = 500
@export var Projectile_Damage : int = 1
var Owner_Character : CharacterBody2D

func _process(delta):
	translate (-transform.y * Projectile_Speed * delta)

func _on_body_entered(body):
	if body == Owner_Character:
		return
	
	if body.has_method("take_damage"):
		body.take_damage(Projectile_Damage)
	
	queue_free()

func _on_despawn_timer_timeout():
	queue_free()
