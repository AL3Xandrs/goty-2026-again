extends StaticBody2D

@onready var interactable: Area2D = $interactable
#@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gameNode = $".."
@onready var playerNode = $"../Player"

var activeScreen
@onready var computerScreen = load("res://scenes/computer_scene.tscn")

func _ready() -> void:
	interactable.interact = _on_interact
	
	var screenInstance = computerScreen.instantiate()
	gameNode.add_child.call_deferred(screenInstance)
	activeScreen = screenInstance
	activeScreen.hide()
	
	
	
	
func _on_interact():
	if !playerNode.isBusy:
		print("comp uter")
		playerNode.isBusy = 1
		activeScreen.show()
	else:
		playerNode.isBusy = 0
		activeScreen.hide()
	
