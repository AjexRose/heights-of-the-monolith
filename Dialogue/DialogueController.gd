class_name DialogueController
extends Node

var current_dialogue : Dialogue

@onready var dialogue_screen : Panel = $"../HUD/DialogueScreen"
@onready var npc_name_text : Label = $"../HUD/DialogueScreen/DialoguePanel/NPCName"
@onready var npc_title_text: Label = $"../HUD/DialogueScreen/DialoguePanel/NPCTitle"
@onready var npc_icon : TextureRect = $"../HUD/DialogueScreen/DialoguePanel/NPCIcon"
@onready var npc_dialogue_text : Label = $"../HUD/DialogueScreen/DialoguePanel/NPCDialogue"

@onready var player : Player = $".."

var visible_text_chars : float
var text_speed : float = 30
var current_line : int

func _ready():
	_close_screen()
	
func set_dialogue(dialogue : Dialogue):
	current_dialogue = dialogue
	
	dialogue_screen.visible = true
	npc_name_text.text = dialogue.npc_name
	npc_title_text.text = dialogue.npc_title
	npc_icon.texture = dialogue.npc_icon

	current_line = 0
	_set_line(dialogue.lines[0])
	
	player._toggle_usability(false)

func _process(delta : float):
	visible_text_chars += text_speed * delta
	npc_dialogue_text.visible_characters = int(visible_text_chars)

	if not current_dialogue:
		return
		
	if Input.is_action_just_pressed("World_Interaction"):
		if len(current_dialogue.lines) == current_line + 1:
			if current_dialogue.item_to_give:
				for i in range(current_dialogue.item_to_give_quantity):
					player.Player_Inventory.add_item(current_dialogue.item_to_give)
			if current_dialogue.item_to_take:
				for i in range(current_dialogue.item_to_take_quantity):
					player.Player_Inventory.remove_item(current_dialogue.item_to_take)
			_close_screen()
		else:
			current_line += 1
			_set_line(current_dialogue.lines[current_line])

func _set_line (line : String):
	visible_text_chars = 0
	npc_dialogue_text.visible_characters = 0
	npc_dialogue_text.text = line
	
func _close_screen():
	dialogue_screen.visible = false
	current_dialogue = null
	
	player._toggle_usability(true)
