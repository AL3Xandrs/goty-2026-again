extends Node2D

const GAME_STATE_PAUSED = 0
const GAME_STATE_RUNNING = 1

@onready var mainMenuScene = $"./MainMenu"
@onready var gameNode = $"./game"
@onready var endingScreen = load("res://scenes/end_screen.tscn")
@onready var gameScene = load("res://scenes/game.tscn")
@onready var MainMenuScene = load("res://scenes/main_menu.tscn")

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
		if child is MainMenuClass:
			child.queue_free()
		elif child is Game:
			var fader = create_tween()
			fader.tween_property(child,"modulate:a", 0, 1.0)
			await fader.finished
			child.queue_free()
		elif child is not Sprite2D and child is not Camera2D:
			child.queue_free()
	await get_tree().create_timer(1.1).timeout
	get_tree().paused = false
	if typeOfEnding != "Reset":
		var screen = endingScreen.instantiate()
		screen.type = typeOfEnding
		add_child(screen)
		await screen.done
		screen.queue_free()
	await get_tree().create_timer(2.0, false).timeout
	gameNode = gameScene.instantiate()
	add_child(gameNode)
	gameNode.modulate.a = 0
	mainMenuScene = MainMenuScene.instantiate()
	add_child(mainMenuScene)
	get_tree().paused = true
	var fader = create_tween()
	fader.tween_property(gameNode, "modulate:a", 1, 1)
	await fader.finished
	isPausable = 1
	
