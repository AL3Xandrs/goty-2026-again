class_name DealerNode
extends Node2D

const VALUE: int = 0
const SUIT: int = 1

var dealerHand: Array
var dealerHiddenCard: Card
@onready var cardScene = load("res://blackjack/card_scene.tscn")
@onready var cardStack := $"../CardStackNode"

func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass
	
	
func play():
	dealerHiddenCard.showCard()
	await get_tree().create_timer(1.0).timeout
	while getScore()<=16:
		hit()
		await get_tree().create_timer(1.0).timeout
		
		
func hit() -> void:
	var newCard := _generateRandomCard()
	dealerHand.append(newCard)
	drawCard(newCard)
	await get_tree().create_timer(0.5).timeout # acelasi timp cat animatia de draw)

func _generateRandomCard() -> Array:
	var newCard: Array
	newCard.append(randi_range(1, 13))
	var newSuit: String = ["Red", "Blue", "Green", "Yellow"][randi_range(0,3)]
	newCard.append(newSuit)
	return newCard
	
func getScore() -> int:
	var sum:int = 0
	var aceCount: int = 0
	for card in dealerHand:
		var currentValue: int = card[VALUE]
		sum += min(10, currentValue) # face din face cards in 10 ca la blackjack wow ce chestie
		if currentValue == 1: aceCount+=1
	for i in range(aceCount):
		if sum + 10 <= 21:
			sum += 10 # face asii automat mari daca se poate
	return sum

func drawCard(card: Array):
	var cardInstance = cardScene.instantiate()
	cardInstance.position += Vector2(dealerHand.size() * 40, 0)
	if dealerHand.size() == 2: #if he the 1 card and draw and 
		cardInstance.isHidden = 1
		dealerHiddenCard = cardInstance
	
	var startPosition = cardStack.position - position
	var finalPosition = Vector2(dealerHand.size() * 40, 0)
	cardInstance.startPosition = startPosition
	cardInstance.finalPosition = finalPosition
	
	cardInstance.value = card[VALUE]
	cardInstance.suit = card[SUIT]
	add_child.call_deferred(cardInstance) 
	
func reset():
	for node in get_children():
		node.discard()
	dealerHand.clear()
	
func isBusted() ->bool:
	return (getScore() > 21)
