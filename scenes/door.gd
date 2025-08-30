extends CharacterBody2D

@export var typeOfWindow:String = ""
@onready var interactable: Area2D = $interactable

@onready var gameNode:= $".."

var canInteract: bool = 0

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if canInteract:
		canInteract = 0
		gameNode.startCutscene()
