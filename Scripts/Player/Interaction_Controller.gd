class_name InteractionController
extends Area2D

@onready var prompt_text : Label = $"../HUD/InteractPrompt"
@onready var player : Player = $".."

var world_item : WorldItem
var current_interactable : Interactable
var can_interact : bool = true

func _ready():
	area_entered.connect(_on_trigger_update)
	area_exited.connect(_on_trigger_update)
	_check() #in case start inside a area

func _on_trigger_update(_area: Area2D):
	_check()

func get_interaction_text() -> String:
	var interaction_events = InputMap.action_get_events("World_Interaction")
	
	if interaction_events.size() > 0:
		var event = interaction_events[0]
		
		# get clean name from OS
		if event is InputEventKey:
			return OS.get_keycode_string(event.get_physical_keycode_with_modifiers())
		# Fallback for non-keys (mouse, controllers (if this was done right)
		return event.as_text().replacen("(Physical)", "").strip_edges()
	
	return "None"

func _process(delta : float):
	if not current_interactable:
		return
	
	if Input.is_action_just_pressed("World_Interaction"):
		current_interactable.try_interact(player)

func _check():
	current_interactable = null
	prompt_text.hide()
	
	if not can_interact:
		return
	
	for area in get_overlapping_areas():
		if area is not Interactable:
			continue
		
		if not area.can_interact:
			continue
		
		current_interactable = area
		prompt_text.show()
		#Toggleable in GenericInteractable, to see if it needs a prefix for action. Mainly
		# to handle barkers
		if area.show_key_prefix:
			var bind_name = get_interaction_text()
			prompt_text.text = "[" + bind_name + "] " + area.prompt
		else:
			# Only show the prompt text (e.g., "Talk")
			prompt_text.text = area.prompt

func enable():
	can_interact = true

func disable():
	can_interact = false
	current_interactable = null
	prompt_text.hide()
