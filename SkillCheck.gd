extends Node2D

var speed: float = 1

@onready var movingLine = $"Mover"

signal stop

func _ready() -> void:
	doMoveThingo()
	movingLine.position = Vector2(-280, 0)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		emit_signal("stop")

func doMoveThingo():
	var mover = create_tween()
	mover.tween_property(movingLine,"position", Vector2(280, 0), 1).set_ease(Tween.EASE_IN_OUT)
	mover.tween_property(movingLine,"position", Vector2(-280, 0), 1).set_ease(Tween.EASE_IN_OUT)
	await stop
	mover.kill()
