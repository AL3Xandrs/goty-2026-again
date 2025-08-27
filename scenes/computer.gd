extends StaticBody2D

@onready var interactable: Area2D = $interactable
#@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var blackjack = load("res://blackjack/black_jack_scene.tscn")
@onready var dice = load("res://barbut/barbut_scene.tscn")
@onready var gameNode = $".."
@onready var playerNode = $"../Player"

var activeGame

func _ready() -> void:
	interactable.interact = _on_interact
	#var blackJackInstance = blackjack.instantiate()
	#gameNode.add_child.call_deferred(blackJackInstance)
	#activeGame = blackJackInstance
	var diceInstance = dice.instantiate()
	gameNode.add_child.call_deferred(diceInstance)
	activeGame = diceInstance
	
	activeGame.hide()
	
	
	
func _on_interact():
	if !playerNode.isBusy:
		print("comp uter")
		playerNode.isBusy = 1
		activeGame.show()
	else:
		playerNode.isBusy = 0
		activeGame.hide()
	
