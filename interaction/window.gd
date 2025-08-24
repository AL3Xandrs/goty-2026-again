extends StaticBody2D

@onready var interactable: Area2D = $interactable
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	interactable.interact = _on_interact
	
	
func _on_interact():
	#if interactable.is_interactable == true:
		#interactable.is_interactable = false;
		print("s-a inchis")
	
