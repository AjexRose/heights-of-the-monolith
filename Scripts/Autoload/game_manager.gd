extends Node

var player : Player
var camera : Camera2D

func change_scene(scene : PackedScene, player_position : Vector2):
	get_tree().change_scene_to_packed(scene)
	
	# Wait for the next frame so the new Level is instanced
	await get_tree().process_frame
	
	# RE-FIND the new player instance in the new scene
	player = get_tree().get_first_node_in_group("Player")
	
	if player:
		player.global_position = player_position
		# Safety: ensure GameManager's player reference is updated
		if camera:
			camera.target = player
			camera.force_snap()

	get_tree().root.move_child(player, get_tree().root.get_child_count()-1)

func _update_position(pos : Vector2):
	if player:
		player.global_position = pos
	if camera:
		camera.global_position = pos
