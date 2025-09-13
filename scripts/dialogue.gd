class_name DialogueBox
extends Node2D


@onready var dialogueLine:= $"DialogueLine"
@onready var playerSprite:= $"Headu"
@onready var landlordSprite:= $"Headlordofland"
@onready var uninteractiveLabel:=$"UninteractiveLabel"
@onready var buttonsNode:=$"./Buttons"
@onready var mainNode = get_tree().get_root().get_node("main")
@onready var gameNode:= $".."
var text: String = "This is the default text"
var speaker: String = "tf?"
var isInteractive: bool = 0

signal done

func _ready() -> void:
	if !isInteractive:
		uninteractiveLabel.show()
	modulate.a = 0
	position = Vector2(0, 100)
	process_mode = Node.PROCESS_MODE_ALWAYS
	showDialogue()
	get_tree().paused = true
	dialogueLine.text = text
	match speaker:
		"Player": playerSprite.show()
		"Landlord": landlordSprite.show()
		_: print("!! Warning: speaker should be either Player or Landlord")
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if ! isInteractive:
			clearDialogue()

func showDialogue():
	var fader = create_tween()
	var mover = create_tween()
	mover.tween_property(self, "position", Vector2(0, 0), 0.2)
	fader.tween_property(self, "modulate:a", 1, 0.2)
	await fader.finished
	if isInteractive:
		showButtons()
	
func clearDialogue():
	var fader = create_tween()
	var mover = create_tween()
	mover.tween_property(self, "position", Vector2(0, 50), 0.2)
	fader.tween_property(self, "modulate:a", 0, 0.2)
	await fader.finished
	get_tree().paused = false
	emit_signal("done")
	queue_free()

func showButtons():
	buttonsNode.modulate.a = 0
	buttonsNode.show()
	var fader = create_tween()
	fader.tween_property(buttonsNode, "modulate:a", 1, 0.2)
	
	


func _onPressContinue(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		clearDialogue()


func _onPressStop(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		await clearDialogue()
		mainNode.endRun("Pussy " + str(gameNode.level))
