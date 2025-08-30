extends StaticBody2D


@export var typeOfWindow:String = ""
@onready var interactable: Area2D = $interactable

@onready var bottomWindowSprite: Sprite2D = $BottomWindowSprite
@onready var topWindowSprite: Sprite2D = $TopWindowSprite
@onready var bottomWindowOpen: Sprite2D = $BottomWindowOpen
@onready var topWindowOpen: Sprite2D = $TopWindowOpen
@onready var topWindowBroken: Sprite2D = $TopWindowBreak
@onready var bottomWindowBroken: Sprite2D = $BottomWindowBreak

@onready var landlord: Sprite2D = $Lordoflandfall

@onready var noiseMakerBottom= $KnockingSoundBottom
@onready var noiseMakerTop= $KnockingSoundTop

@onready var mainNode = get_tree().get_root().get_node("main")
@onready var gameNode = $".."
@onready var computerNode = $"../Computer"
@onready var skillCheck = load("res://scenes/skill_check.tscn")

var currentWindow
var currentWindowOpen
var currentWindowBroken
var currentNoiseMaker
# var botherScore: int 
var pushed = 1

func _ready() -> void:
	interactable.interact = _on_interact
	if typeOfWindow == "Bottom Window":
		currentWindow = bottomWindowSprite
		currentWindowOpen = bottomWindowOpen
		currentNoiseMaker = noiseMakerBottom
		currentWindowBroken = bottomWindowBroken
	elif typeOfWindow == "Top Window":
		currentWindow = topWindowSprite
		currentWindowOpen = topWindowOpen
		currentNoiseMaker = noiseMakerTop
		currentWindowBroken = topWindowBroken
	currentWindow.show()
	
	
func _on_interact():
	if !pushed and gameNode.failCount <3:
		var skill = skillCheck.instantiate()
		add_child(skill)
		await get_tree().create_timer(0.1, false).timeout
		if pushed:
			closeWindow()
			print("s-a inchis")
		else: gameNode.failCount+=1

func botherPlayer(bother: int):
	openWindow()
	pushed = 0
	currentNoiseMaker.play()
	await get_tree().create_timer(5.0, false).timeout
	if !pushed:
		breakWindow()
		landlordWindowBreak()

func openWindow():
	currentWindow.hide()
	currentWindowOpen.show()

func closeWindow():
	currentWindowOpen.hide()
	currentWindow.show()
func breakWindow():
	currentWindowOpen.hide()
	currentWindow.hide()
	currentWindowBroken.show()

func landlordWindowBreak():
	landlord.show()
	computerNode.killScreen()
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	mainNode.isPausable = 0
	var faller = create_tween()
	if typeOfWindow == "Bottom Window":
		landlord.frame = 1
		landlord.position = Vector2(0, -50)
		faller.tween_property(landlord, "position", Vector2(0, -200), 0.6)
	elif typeOfWindow == "Top Window":
		landlord.frame = 0
		landlord.position = Vector2(0, 50)
		faller.tween_property(landlord, "position", Vector2(0, 200), 0.6)
	await faller.finished
	await get_tree().create_timer(0.6).timeout
	mainNode.endRun("Jumpscare")
