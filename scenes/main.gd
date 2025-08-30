extends Node2D

const GAME_STATE_PAUSED = 0
const GAME_STATE_RUNNING = 1

@onready var mainMenuScene = $"./MainMenu"
@onready var game = $"./game"
var gameState:bool = GAME_STATE_PAUSED
var isPausable:bool = 1
func _ready() -> void:
	pause()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if!mainMenuScene.isInAnimation:
			pause()
	
func unpause():
	if isPausable:
		mainMenuScene.hideMenu()
		get_tree().paused = false
func pause():
	if isPausable:
		mainMenuScene.showMenu()
		get_tree().paused = true
	

func _process(delta: float) -> void:
	pass

func endRun(typeOfEnding: String):
	print(typeOfEnding)
	get_tree().paused = true
	for child in get_children():
		if child is Game:
			var fader = create_tween()
			fader.tween_property(child,"modulate:a", 0, 1.0)
			await fader.finished
		if child is not Sprite2D and child is not Camera2D:
			child.queue_free()
	# TODO: cool ending screen
	# reset game and mainMenu ty shi
