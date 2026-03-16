class_name Dialogue
extends Resource

@export var npc_name : String
@export var npc_title : String
@export var npc_icon : Texture2D

@export var lines : Array[String]

@export var item_to_give : BaseItemData
@export var item_to_give_quantity : int = 0

@export var item_to_take : BaseItemData
@export var item_to_take_quantity : int = 0
