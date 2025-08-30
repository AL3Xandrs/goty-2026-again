extends Node2D

@onready var ball = $"Wheel/RouletteBall"
@onready var wheel = $"Wheel/WheelSprite"

var type: String = "Finale"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	match type:
		"Finale": runFinale()


func runFinale():
	var spinner = create_tween()
	spinner.tween_property(wheel,"rotation", 35, 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	spinner.tween_property(wheel,"rotation", 70, 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
#spinner.tween_property(wheel,"rotation", 75, 5)
