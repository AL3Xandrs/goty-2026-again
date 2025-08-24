extends Node2D

const PLAYERS_TURN: int = 1
const DEALERS_TURN: int = 2

var currentTurn: int = 1

@onready var dealerNode: DealerNode = $"./dealerHand"
@onready var playerNode: PlayerNode  = $"./playerHand"
@onready var buttonsNode = $"./buttons"
@onready var cardScene = load("res://scenes/card_scene.tscn")
@onready var players: Array = [playerNode, dealerNode]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass



func runDealer():
	if (currentTurn == DEALERS_TURN):
		currentTurn = 3
		await dealerNode.play()
		print(dealerNode.getScore())
		currentTurn = PLAYERS_TURN
		await get_tree().create_timer(3.0).timeout
		runWin()
		dealerNode.reset()
		playerNode.reset()

func hit():
	buttonsNode.hide()
	playerNode.hit()
	print(playerNode.playerHand)
	print(playerNode.getScore())
	if playerNode.isBusted():
			currentTurn = DEALERS_TURN
			await runDealer()
	
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

func runWin():
	pass
