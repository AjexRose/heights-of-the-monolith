class_name DialogueBarkController
extends Node

var current_dialogue_bark : DialogueBark
var barker : Node2D

@onready var dialogue_bark_screen : Panel = $"../HUD/DialogueBarkScreen"
@onready var barker_name_text : Label = $"../HUD/DialogueBarkScreen/DialogueBarkPanel_BG/BarkerTitle"
@onready var barker_dialogue_text : Label = $"../HUD/DialogueBarkScreen/DialogueBarkPanel_BG/BarkerText"

@onready var player : Player = $".."

var visible_text_chars : float
var text_speed : float = 60
var current_line : int

func _ready():
	_close_screen()

func _update_ui_position():
	if barker and barker.bark_location:
		var world_pos = barker.bark_location.global_position
		var screen_pos = get_viewport().get_canvas_transform() * world_pos
		dialogue_bark_screen.global_position = screen_pos - (dialogue_bark_screen.size / 2.0)

func set_bark_dialogue(dialoguebark : DialogueBark, barkerEntity : Node):
	barker = barkerEntity
	current_dialogue_bark = dialoguebark
	barker_name_text.text = dialoguebark.barker_name
	current_line = 0
	_set_line(dialoguebark.lines[0])
	_update_ui_position() 
	dialogue_bark_screen.visible = true 

func _process(delta : float):
	if barker == null:
		return
	
	_update_ui_position() #Updates per frame so it stays while the camera moves
	
	visible_text_chars += text_speed * delta
	barker_dialogue_text.visible_characters = int(visible_text_chars)
	
	if not current_dialogue_bark:
		return
		
	if Input.is_action_just_pressed("World_Interaction"):
		if len(current_dialogue_bark.lines) == current_line + 1:
			_close_screen()
		else:
			current_line += 1
			_set_line(current_dialogue_bark.lines[current_line])

func _set_line (line : String):
	visible_text_chars = 0
	barker_dialogue_text.visible_characters = 0
	barker_dialogue_text.text = line
	dialogue_bark_screen.reset_size() 
	
func _close_screen():
	dialogue_bark_screen.visible = false
	current_dialogue_bark = null
	barker = null
