extends Node2D

@onready var blackjack = load("res://blackjack/black_jack_scene.tscn")
@onready var dice = load("res://barbut/barbut_scene.tscn")
@onready var gameNode = $"../.."
@onready var playerNode = $"../../Player"

@onready var buttonsNode = $"./Buttons"
@onready var barbutButton = $"./Buttons/BarbutButton"
@onready var blackjackButton = $"./Buttons/BlackjackButton"
@onready var slotsButton = $"./Buttons/SlotsButton"
var activeGame

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _onPressBarbutButton(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var barbutInstance = dice.instantiate()
		add_child.call_deferred(barbutInstance)
		activeGame = barbutInstance
		buttonsNode.hide()


func _onClickBlackjack(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var blackjackInstance = blackjack.instantiate()
		add_child.call_deferred(blackjackInstance)
		activeGame = blackjackInstance
		buttonsNode.hide()


func _onClickSlots(event: InputEvent) -> void:
	pass # Replace with function body.


func _onMouseEnteredBarbut() -> void:
	barbutButton.scale = Vector2(1.5, 1.5)


func _onMouseExitBarbut() -> void:
	barbutButton.scale = Vector2(1, 1)
