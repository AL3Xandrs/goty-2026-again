extends Node2D

const PLAYERS_TURN: int = 1
const DEALERS_TURN: int = 2

var currentTurn: int = 3

@onready var dealerNode: DealerNode = $"./dealerHand"
@onready var playerNode: PlayerNode  = $"./playerHand"
@onready var buttonsNode = $"./buttons"
@onready var cardScene = load("res://scenes/card_scene.tscn")
@onready var players: Array = [playerNode, dealerNode]
@onready var victoryScreen := $"./endingScreens/VictoryScreen"
@onready var defeatScreen := $"./endingScreens/DefeatScreen"
@onready var drawScreen := $"./endingScreens/DrawScreen"
@onready var betNode := $"./Bet"
@onready var betSlider := $"./Bet/BetSlider"
@onready var betLabel := $"./Bet/BetLabel"
@onready var betButton := $"./Bet/BetButton"
@onready var gameNode = get_tree().get_root().get_node("./main/game")

var betAmount:int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	startBet()

func _process(delta: float) -> void:
	pass



func runDealer():
	if (currentTurn == DEALERS_TURN):
		currentTurn = 3
		await dealerNode.play()
		print(dealerNode.getScore())
		currentTurn = PLAYERS_TURN
		endGame()
		await get_tree().create_timer(1.0, false).timeout
		startBet()

func hit():
	buttonsNode.hide()
	await playerNode.hit()
	print(playerNode.playerHand)
	print(playerNode.getScore())
	if playerNode.isBusted():
		await get_tree().create_timer(1.0, false).timeout
		startBet()
	else:
		buttonsNode.show()

func stand():
	buttonsNode.hide()
	currentTurn = DEALERS_TURN
	await runDealer()
	


func _onClickHit(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		# ^ cand apesi pe butonu hit practic
		hit() # <- nebunie

func _onClickStand(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		# ^ cand apesi pe butonu stand practic
		stand() # <- traznaie

func endGame():
	#TODO: cand am acces la player si alea sa fac chiar sa piarda bani si sa castige
	if playerNode.getScore() > dealerNode.getScore() or dealerNode.isBusted():
		print("Player won yippie")
		gameNode.money += betAmount
		victoryScreen.show()
		await get_tree().create_timer(1.5, false).timeout
		victoryScreen.hide()
	elif playerNode.getScore() < dealerNode.getScore():
		print("Dealer won rigged")
		gameNode.money -= betAmount
		defeatScreen.show()
		await get_tree().create_timer(1.5, false).timeout
		defeatScreen.hide()
	else:
		print("wow its a draw :i")
		drawScreen.show()
		await get_tree().create_timer(1.5, false).timeout
		drawScreen.hide()

func startGame():
	buttonsNode.hide()
	await playerNode.hit()
	await dealerNode.hit()
	await playerNode.hit()
	await dealerNode.hit()
	currentTurn = PLAYERS_TURN
	buttonsNode.show()

func startBet():
	dealerNode.reset()
	playerNode.reset()
	buttonsNode.hide()
	betNode.show()
	betAmount = 0
	betSlider.max_value = gameNode.money
	betSlider.value = int(gameNode.money/2)
	betNode.show()


func _onPressBet(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		betNode.hide()
		betAmount = betSlider.value
		startGame()


func _onBetSliderSlide(value: float) -> void:
	betLabel.text = "Bet: $" + str(int(betSlider.value))
