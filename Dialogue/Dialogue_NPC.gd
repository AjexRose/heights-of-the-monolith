class_name DialogueNPC
extends Node2D

@export var dialogue : Dialogue
@onready var interactable : Interactable = $"../InteractionArea"

func _ready():
	interactable.Interact.connect(_on_interact)

func _on_interact (player : Player):
	player.Dialogue_Controller.set_dialogue(dialogue)
