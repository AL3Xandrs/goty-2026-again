class_name PlayerNode
extends Node2D

const VALUE: int = 0
const SUIT: int = 1
const WEIGHT: int = 2

var playerHand: Array
@onready var cardScene = load("res://blackjack/card_scene.tscn")
@onready var cardStack := $"../CardStackNode"

func _ready() -> void:
	playerHand.clear()

func hit() -> void:
	var newCard := _generateWeightedCard()
	playerHand.append(newCard)
	drawCard(newCard)
	await get_tree().create_timer(0.5).timeout # acelasi timp cat animatia de draw
	

func getScore() -> int:
	var sum:int = 0
	var aceCount: int = 0
	for card in playerHand:
		var currentValue: int = card[VALUE]
		sum += min(10, currentValue) # face din face cards in 10 ca la blackjack wow ce chestie
		if currentValue == 1: aceCount+=1
	for i in range(aceCount):
		if sum + 10 <= 21:
			sum += 10 # face asii automat mari daca se poate
	return sum
	

func _generateWeightedCard() -> Array:
	var finalCard: Array
	var drawnCards: Array
	var handScore: int = getScore()
	var maxWeight: int = -99
	
	for i in range(5): # cu avantaj :alien:
		var newCard := _generateRandomCard()
		#while newCard not in playerHand:     # to no thave repeats
		#	newCard = _generateRandomCard()   # ts crashes godot xdd xd
		var weight: int = handScore + newCard[VALUE]
		if weight > 21:
			weight = -1
		if weight > maxWeight:
			maxWeight = weight
		newCard.append(weight)
		drawnCards.append(newCard)
	
	for card in drawnCards:
		if card[WEIGHT] == maxWeight:
			finalCard = [card[VALUE], card[SUIT]]
			break
	
	return finalCard




func _generateRandomCard() -> Array:
	var newCard: Array
	newCard.append(randi_range(1, 13))
	var newSuit: String = ["Red", "Blue", "Green", "Yellow"][randi_range(0,3)]
	newCard.append(newSuit)
	return newCard


func drawCard(card: Array):
	var cardInstance = cardScene.instantiate()
	var startPosition = cardStack.position - position
	var finalPosition = Vector2(playerHand.size() * 40, 0)
	cardInstance.startPosition = startPosition
	cardInstance.finalPosition = finalPosition
	cardInstance.value = card[VALUE]
	cardInstance.suit = card[SUIT]
	add_child.call_deferred(cardInstance)
	

func reset():
	for node in get_children():
		node.discard()
	playerHand.clear()
func isBusted() ->bool:
	return (getScore() > 21)
	
