extends StaticBody2D


@export var typeOfWindow:String = ""
@onready var interactable: Area2D = $interactable

@onready var bottomWindowSprite: Sprite2D = $BottomWindowSprite
@onready var topWindowSprite: Sprite2D = $TopWindowSprite
@onready var bottomWindowOpen: Sprite2D = $BottomWindowOpen
@onready var topWindowOpen: Sprite2D = $TopWindowOpen

@onready var noiseMakerBottom= $KnockingSoundBottom
@onready var noiseMakerTop= $KnockingSoundTop
var currentWindow
var currentWindowOpen
var currentNoiseMaker
var botherScore: int 

func _ready() -> void:
	interactable.interact = _on_interact
	if typeOfWindow == "Bottom Window":
		currentWindow = bottomWindowSprite
		currentWindowOpen = bottomWindowOpen
		currentNoiseMaker = noiseMakerBottom
	elif typeOfWindow == "Top Window":
		currentWindow = topWindowSprite
		currentWindowOpen = topWindowOpen
		currentNoiseMaker = noiseMakerTop
	currentWindow.show()
	
	
func _on_interact():
	botherScore -= 1
	if botherScore == 0:
		closeWindow()
	print("s-a inchis")

func botherPlayer(bother: int):
	botherScore = bother
	openWindow()
	currentNoiseMaker.play()
	await get_tree().create_timer(5.0, false).timeout
	if botherScore > 0:
		print(typeOfWindow) # and end the game maybe

func openWindow():
	currentWindow.hide()
	currentWindowOpen.show()

func closeWindow():
	currentWindowOpen.hide()
	currentWindow.show()
