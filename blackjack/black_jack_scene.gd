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
func _ready() -> void:
	startGame()

func _process(delta: float) -> void:
	pass



func runDealer():
	if (currentTurn == DEALERS_TURN):
		currentTurn = 3
		await dealerNode.play()
		print(dealerNode.getScore())
		currentTurn = PLAYERS_TURN
		endGame()
		await get_tree().create_timer(1.0).timeout
		await startGame()

func hit():
	buttonsNode.hide()
	await playerNode.hit()
	print(playerNode.playerHand)
	print(playerNode.getScore())
	if playerNode.isBusted():
		await get_tree().create_timer(1.0).timeout
		startGame()
	
	buttonsNode.show()

func stand():
	buttonsNode.hide()
	currentTurn = DEALERS_TURN
	await runDealer()
	buttonsNode.show()


func _onClickHit(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		# ^ cand apesi pe butonu hit practic
		hit() # <- nebunie

func _onClickStand(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		# ^ cand apesi pe butonu stand practic
		stand() # <- traznaie

func endGame():
	#TODO: cand am acces la player si alea sa fac chiar sa piarda bani si sa castige
	if playerNode.getScore() > dealerNode.getScore() or dealerNode.isBusted():
		print("Player won yippie")
		victoryScreen.show()
		await get_tree().create_timer(1.5).timeout
		victoryScreen.hide()
	elif playerNode.getScore() < dealerNode.getScore():
		print("Dealer won rigged")
		defeatScreen.show()
		await get_tree().create_timer(1.5).timeout
		defeatScreen.hide()
	else:
		print("wow its a draw :i")
		drawScreen.show()
		await get_tree().create_timer(1.5).timeout
		drawScreen.hide()

func startGame():
	buttonsNode.hide()
	dealerNode.reset()
	playerNode.reset()
	await playerNode.hit()
	await dealerNode.hit()
	await playerNode.hit()
	await dealerNode.hit()
	currentTurn = PLAYERS_TURN
	buttonsNode.show()
