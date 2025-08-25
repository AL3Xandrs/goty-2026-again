class_name Card
extends Node2D


var suit: String
var value: int
var isHidden:bool
var finalPosition:Vector2
var startPosition: Vector2
@onready var redCards:Sprite2D = $"./TilesetRed"
@onready var greenCards:Sprite2D = $"./TilesetGreen"
@onready var blueCards:Sprite2D = $"./TilesetBlue"
@onready var yellowCards:Sprite2D = $"./TilesetYellow"
@onready var backOfTheCard:Sprite2D = $"./CardBack"
var currentSprite:Sprite2D

func _ready() -> void:
	position = startPosition
	if suit == "Red": currentSprite = redCards
	elif suit == "Green": currentSprite = greenCards
	elif suit == "Blue": currentSprite = blueCards
	elif suit == "Yellow": currentSprite = yellowCards
	currentSprite.show()
	backOfTheCard.show()
	currentSprite.region_rect.position = Vector2(50*((value-1)%5),int(69*((value-1)/5)))
	
	var gliderThingo = create_tween()
	gliderThingo.tween_property(self, "position", finalPosition, 0.5)
	await gliderThingo.finished
	
	if !isHidden:
		backOfTheCard.hide()

func showCard():
	backOfTheCard.hide()

func discard():
	var gliderThingo = create_tween()
	gliderThingo.tween_property(self, "position", startPosition, 0.3)
	await gliderThingo.finished
	queue_free()

func _process(delta: float) -> void:
	pass
