class_name PortalInteraction
extends Node2D

#Holds the scene, duh
@export_file("*tscn") var Scene_To_Load : String
@export var enter_position : Vector2

#Uses the player InteractionController to determine when interacted
#THIS MEANS THE PORTAL NEEDS A AREA2D NODE CHILD WITH THE INTERACTABLE SCRIPT ATTACHED
#DO NOT FORGET THIS ME!! ^^^
func _ready():
	$Interactable.Interact.connect(_on_interact)

#Changes scenes... should be obvi.
func _on_interact (player : Player):
	var scene : PackedScene = load(Scene_To_Load)
	GameManager.change_scene(scene, enter_position)
