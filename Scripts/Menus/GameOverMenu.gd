extends CanvasLayer

@export_file("*tscn") var Scene_To_Load : String
@export var enter_position : Vector2

func _ready():
	self.hide()

func _on_retry_btn_pressed() -> void:
	self.hide()
	var scene : PackedScene = load(Scene_To_Load)
	GameManager.change_scene(scene, enter_position)
	
	if GameManager.player:
		GameManager.player.Current_Health = GameManager.player.Max_Health
		GameManager.player.Current_Shield = GameManager.player.Max_Shield
		GameManager.player.Player_Sprite.show()
		GameManager.player.Weapon_Sprite.show()
		GameManager.player.Can_Use = true
		GameManager.player.Can_Move = true

func _on_quit_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/Main_Menu.tscn")
