class_name Interactable
extends Area2D

signal Interact (player : Player)

@export var prompt : String = "INTERACT"
@export var single_use : bool = false
@export var show_key_prefix : bool = true

var can_interact : bool = true

func try_interact(player: Player):
	if not can_interact:
		return
	
	Interact.emit(player)
	
	if single_use:
		can_interact = false
