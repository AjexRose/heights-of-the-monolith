extends Node

var player : Player
var camera : PlayerCamera 

func change_scene(scene : PackedScene, player_position : Vector2):
	# Detach player from the old level so they aren't destroyed
	if player and player.get_parent():
		#print("DEBUG: Rescuing Player from ", player.get_parent().name)
		player.reparent(self)
	
	#LOAD PHASE
	get_tree().change_scene_to_packed(scene)
	#print("DEBUG: Scene change requested...")
	
	# Wait until the old scene is gone and the new one is 'ready'
	await get_tree().process_frame # Frame 1: Old scene deleted
	await get_tree().process_frame # Frame 2: New scene instigated
	
	# Safety Loop: Keep waiting if scene is not ready
	while get_tree().current_scene == null:
		await get_tree().process_frame
		
	# LOAD PLAYER PHASE
	var active_level = get_tree().current_scene
	#print("DEBUG: Target Level found: ", active_level.name)
	
	if player:
		# Prevents having 2 players: the persistent one + the level's default one
		var dummy_player = active_level.find_child("Player", true, false)
		if dummy_player:
			print("DEBUG: Deleting dummy player in new scene")
			dummy_player.queue_free()
		
		# Move player into the level
		player.reparent(active_level)
		player.global_position = player_position
		#print("DEBUG: Player successfully injected into ", active_level.name)
		
		# Re-link Camera
		if camera:
			camera.target = player
			camera.force_snap()

func _update_position(pos : Vector2):
	if player:
		player.global_position = pos
	if camera:
		camera.global_position = pos
