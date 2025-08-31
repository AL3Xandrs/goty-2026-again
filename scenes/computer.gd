extends StaticBody2D

@onready var interactable: Area2D = $interactable
#@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gameNode = $".."
@onready var playerNode = $"../Player"
@onready var computer_music: AudioStreamPlayer2D = $"../Audio/computer_music"
@onready var room_music: AudioStreamPlayer2D = $"../Audio/room_music"

var activeScreen
@onready var computerScreen = load("res://scenes/computer_scene.tscn")
@onready var dialogue = load("res://scenes/Dialogue.tscn")
func _ready() -> void:
	computer_music.process_mode = Node.PROCESS_MODE_ALWAYS
	room_music.process_mode = Node.PROCESS_MODE_ALWAYS
	room_music.play()
	interactable.interact = _on_interact
	
	var screenInstance = computerScreen.instantiate()
	gameNode.add_child.call_deferred(screenInstance)
	activeScreen = screenInstance
	activeScreen.hide()
	
	
	
	
func _on_interact():
	if gameNode.gameStarted:
		if !playerNode.isBusy:
			print("comp uter")
			playerNode.isBusy = 1
			activeScreen.show()
			if !computer_music.playing:
				computer_music.play()
			computer_music.volume_db = -20
			room_music.volume_db = -80
		else:
			playerNode.isBusy = 0
			activeScreen.hide()
			computer_music.volume_db = -80
			room_music.volume_db = -20

func updateLevel():
	print("a")
	activeScreen.updateLevel()

func killScreen():
	activeScreen.queue_free()
