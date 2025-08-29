extends Node2D

@onready var label := $"./MoneyLabel"

@onready var topWindow := $"./Window"
@onready var bottomWindow := $"./BottomWindow"


@onready var computer = $"./Computer"

const LEVEL_2_THRESHOLD: int = 500
const LEVEL_3_THRESHOLD: int = 2000

var money: int = 0 : set = setMoney
var level: int = 1

var time:float = 0
var botherInterval :float = 10


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	money=499
	

func _process(delta: float) -> void:
	time+=delta
	if time >= botherInterval:
		botherPlayer()
		time = 0


func botherPlayer():
	var randomBother = randi_range(0, 1)
	if randomBother == 0:
		bottomWindow.botherPlayer(randi_range(2, 4))
	else: 
		topWindow.botherPlayer(randi_range(2, 4))
		

func setMoney(value):
	var fancyMoner :Tween = create_tween()
	fancyMoner.tween_method(Callable.create(self, "_updateLabel"), money, value, 0.5)
	money = value
	
	if money > LEVEL_3_THRESHOLD and level != 3:
		print("moving to level 3")
		level = 3
		computer.updateLevel()
	elif money > LEVEL_2_THRESHOLD and level != 2:
		print("moving to level 2")
		level = 2
		computer.updateLevel()

func _updateLabel(value):
	label.text = "$ " + str(value)
