class_name DealerNode
extends Node2D

const VALUE: int = 0
const SUIT: int = 1

var dealerHand: Array

@onready var cardScene = load("res://blackjack/card_scene.tscn")

func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass
	
	
func play():
	while getScore()<=16:
		hit()
		await get_tree().create_timer(1.0).timeout
		
		
func hit():
	var newCard := _generateRandomCard()
	drawCard(newCard)
	dealerHand.append(newCard)

func _generateRandomCard() -> Array:
	var newCard: Array
	newCard.append(randi_range(1, 13))
	var newSuit: String = ["Spades", "Hearts", "Diamonds", "Clubs"][randi_range(0,3)]
	newCard.append(newSuit)
	return newCard
	
func getScore() -> int:
	var sum:int = 0
	var aceCount: int = 0
	for card in dealerHand:
		var currentValue: int = card[VALUE]
		sum += min(10, currentValue) # face din face cards in 10 ca la blackjack wow ce chestie
	for i in range(aceCount):
		if sum + 10 <= 21:
			sum += 10 # face asii automat mari daca se poate
	return sum

func drawCard(card: Array):
	var cardInstance = cardScene.instantiate()
	cardInstance.position += Vector2(dealerHand.size() * 40, 0)
	add_child.call_deferred(cardInstance) 

func reset():
	for node in get_children():
		node.queue_free()
	dealerHand.clear()
	
func isBusted() ->bool:
	return (getScore() > 21)
