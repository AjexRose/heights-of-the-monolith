class_name DialogueBarkerNPC
extends Node2D

@export var dialogue_bark : DialogueBark
@onready var interactable : Interactable = $"../InteractionArea"
@onready var bark_location : Marker2D = $"../BarkLocator"


func _on_interaction_area_area_entered(area: Area2D):
	if area is InteractionController:
		var player = area.player 
		player.Dialogue_Bark_Controller.set_bark_dialogue(dialogue_bark, self)
