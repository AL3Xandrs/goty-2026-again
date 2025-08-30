extends Node2D

@onready var movingLine := $"Background/Mover"
@onready var bar := $"Background"

@onready var barStart := $"Background/Start"
@onready var barEnd := $"Background/End"

@onready var hitZone := $"Background/HitZone"
@onready var landStart := $"Background/HitZone/GoodStart"
@onready var landEnd:= $"Background/HitZone/GoodEnd"


@onready var windowNode :=$".."

signal stop

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	global_position = Vector2(0, 0)
	doMoveThingo()
	hitZone.position.x = randi_range(barStart.position.x + (landEnd.position.x-landStart.position.x), barEnd.position.x - (landEnd.position.x-landStart.position.x))
	hitZone.position = hitZone.position
	movingLine.position = barStart.position
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if movingLine.global_position.x >= landStart.global_position.x and movingLine.global_position.x <= landEnd.global_position.x:
			print("you win")
			windowNode.pushed = 1
		emit_signal("stop")
		
		

func doMoveThingo():
	var mover = create_tween()
	mover.tween_property(movingLine,"position", barEnd.position, 1).set_ease(Tween.EASE_IN_OUT)
	mover.tween_property(movingLine,"position", barStart.position, 1).set_ease(Tween.EASE_IN_OUT)
	await stop
	mover.kill()
	finish()

func finish():
	get_tree().paused = false
	var fader = create_tween()
	fader.tween_property(self, "modulate:a", 0, 0.5)
	await fader.finished
	queue_free()
