class_name DialogueNPC
extends Node2D

var player : Player 
@onready var interactable : Interactable = $"../InteractionArea"
@onready var dialog_player : DialogPlayer = $"../DialogPlayer"

func _ready():
	interactable.Interact.connect(_on_interact)
	SproutyDialogs.dialog_ended.connect(_on_dialog_ended)

func _on_interact(active_player : Player):
	player = active_player 
	
	if player:
		player.Can_Move = false
		player.Can_Use = false
	
	dialog_player.start()

func _on_dialog_ended():
	if player:
		player.Can_Move = true
		player.Can_Use = true
		print("Dialogue Over")
