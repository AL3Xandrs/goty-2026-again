class_name Grabber
extends Area2D

var dragging: bool = false
var offset:= Vector2(0, 0)

@onready var dice1 := $"Dice1"
@onready var dice2 := $"Dice2"
@onready var dragBox :=$"CollisionShape2D"
@onready var infoLabel := $"InfoLabel"
var dice1Value: int
var dice2Value: int

signal ended

var currentPos: Vector2
var lastPos: Vector2
var throwVelocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dice1.scale = Vector2(2, 2)
	dice2.scale = Vector2(2, 2)
	dice1.process_mode = Node.PROCESS_MODE_DISABLED
	dice2.process_mode = Node.PROCESS_MODE_DISABLED
	dice1.value = dice1Value
	dice2.value = dice2Value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		global_position = get_viewport().get_mouse_position() + offset


func _onGrab(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if !dragging:
				infoLabel.hide()
				dragging = true
				offset = global_position - event.position
				updateForce()
		else:
			if dragging:
				dragging = false
				dragBox.disabled = true

func updateForce():
	while(dragging):
		lastPos = currentPos
		currentPos = global_position
		# print(lastPos, currentPos)
		await get_tree().create_timer(0.01, false).timeout
	throwVelocity = currentPos - lastPos
	throwVelocity*= 50
	dice1.process_mode = Node.PROCESS_MODE_INHERIT; dice2.process_mode = Node.PROCESS_MODE_INHERIT
	dice1.draggedThrowVelocity = throwVelocity
	dice2.draggedThrowVelocity = throwVelocity
	dice1.initiateDraggedThrow(); dice2.initiateDraggedThrow()
	await get_tree().create_timer(1.0, false).timeout
	emit_signal("ended")
	

func clearGrabber():
	dice1.clearDie()
	await dice2.clearDie()
	queue_free()
