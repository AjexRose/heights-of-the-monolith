class_name BaseItemData
extends Resource

@export var Display_Name: String
@export var Description: String
@export var Current_Stack_Size: int = 1
@export var Max_Stack_Size : int = 1
@export var Chit_Value : int = 0
var Chit_Value_Total: int = Chit_Value * Current_Stack_Size 
@export var Icon : Texture
@export var Equip_Scene : PackedScene
