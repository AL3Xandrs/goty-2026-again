class_name Game
extends Node2D

@onready var label := $"./MoneyLabel"

@onready var topWindow := $"./Window"
@onready var bottomWindow := $"./BottomWindow"

@onready var dialogue = load("res://scenes/Dialogue.tscn")
@onready var computer = $"./Computer"
@onready var mainNode = get_tree().get_root().get_node("main")

const LEVEL_2_THRESHOLD: int = 500
const LEVEL_3_THRESHOLD: int = 2000
const FINISH_THRESHOLD: int = 10000

var money: int = 0 : set = setMoney
var level: int = 2


var time:float = 0
var botherInterval :float = 10
var isFirstBother: bool = 1

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	money=1000
	

func _process(delta: float) -> void:
	time+=delta
	if time >= botherInterval:
		botherPlayer()
		time = 0


func botherPlayer():
	if isFirstBother:
		await makeDialogue("Luckily there are ladders next to both of your windows!", "Landlord")
		await makeDialogue("Hopefully you cant push them down", "Landlord")
		isFirstBother = 0
	var randomBother = randi_range(0, 1)
	if randomBother == 0:
		bottomWindow.botherPlayer(randi_range(2, 4))
	else: 
		topWindow.botherPlayer(randi_range(2, 4))
		

func setMoney(value):
	var fancyMoner :Tween = create_tween()
	fancyMoner.tween_method(Callable.create(self, "_updateLabel"), money, value, 0.5)
	money = value
	await fancyMoner.finished
	if money == 0:
		mainNode.endRun("Bankrupt")
	
	if money > FINISH_THRESHOLD:
		level = 4
		computer.updateLevel()
	elif money > LEVEL_3_THRESHOLD and level < 3:
		print("moving to level 3")
		level = 3
		computer.updateLevel()
	elif money > LEVEL_2_THRESHOLD and level < 2:
		await get_tree().create_timer(1.0, false).timeout
		await makeDialogue("Wow! That was a very easy way to get the money i needed!", "Player")
		await makeDialogue("I wonder how much more I could get!", "Player")
		await makeDialogue("Hmm.. If i pay the rent now i wont have any money\nto play with...", "Player")
		await makeDialogue("What should i do?", "Player", 1)
		
		print("moving to level 2")
		level = 2
		computer.updateLevel()

func _updateLabel(value):
	label.text = "$ " + str(value)
	
func makeDialogue(text: String, speaker: String, isInteractive: bool = 0):
	var dialogueInstance = dialogue.instantiate()
	dialogueInstance.text = text
	dialogueInstance.speaker = speaker
	dialogueInstance.isInteractive = isInteractive
	add_child(dialogueInstance)
	await get_tree().create_timer(0.01, false).timeout
	
