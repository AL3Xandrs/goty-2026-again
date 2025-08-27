extends Node2D

@onready var betNode = $"./Bet"
@onready var betButton = $"./Bet/BetButton"
@onready var betSlider = $"./Bet/BetSlider"
@onready var betLabel = $"./Bet/BetLabel"

@onready var enemyOrigin = $"./EnemyOrigin".position
@onready var playerOrigin = $"./PlayerOrigin".position

@onready var diceScene = load("res://barbut/dice_scene.tscn")
@onready var gameNode = get_tree().get_root().get_node("./main/game")
var bet: int

var pity:int = 0
var playerDice:Array
var enemyDice:Array


func _ready() -> void:
	startBet()
	betSlider.value = 50


func _process(delta: float) -> void:
	pass


func startBet():
	for child in get_children():
		if child is Dice:
			child.clearDie()
	betNode.show()
	betSlider.max_value = gameNode.money
	#betSlider.value = int (money/2) # ts lowk a bad idea
	
	playerDice.clear()
	enemyDice.clear()

func startGame():
	bet = betSlider.value
	betNode.hide()
	playerDice.append(rollRiggedDice())
	playerDice.append(rollRiggedDice())
	enemyDice.append(rollDice())
	enemyDice.append(rollDice())
	
	await drawEnemyDice()
	await drawPlayerDice()
	
	endGame()

func endGame():
	await get_tree().create_timer(1, false).timeout
	var playerScore:int = playerDice[0] + playerDice[1]
	var enemyScore:int = enemyDice[0] + enemyDice[1]
	if playerScore > enemyScore:
		gameNode.money += bet
		pity = clamp(pity-1, 1, 10)
	elif playerScore < enemyScore:
		gameNode.money -= bet
		pity = clamp(pity+1, 1, 10)
	startBet()

func rollDice() -> int:
	return randi_range(1,6)

func rollRiggedDice() -> int:
	var bestRoll: int = 0
	for i in range(max(1, pity)):
		bestRoll = max(bestRoll, rollDice())
	return bestRoll

func drawEnemyDice():
	for i in range(2):
		var diceInstance: Dice= diceScene.instantiate()
		diceInstance.value = enemyDice[i]
		diceInstance.source = enemyOrigin
		diceInstance.target = position
		add_child.call_deferred(diceInstance)
		await get_tree().create_timer(0.4 * (i+1), false).timeout
		print("Enemy: " + str(enemyDice))

func drawPlayerDice():
	for i in range(2):
		var diceInstance: Dice= diceScene.instantiate()
		diceInstance.value = playerDice[i]
		diceInstance.source = playerOrigin
		diceInstance.target = position
		add_child.call_deferred(diceInstance)
		await get_tree().create_timer(0.4, false).timeout
		print("Player: " + str(playerDice))
		

func _onBetButtonClick(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		startGame()

func _onBetSliderChanged(value: int) -> void:
	betLabel.text = "Bet: $" + str(int(betSlider.value))
