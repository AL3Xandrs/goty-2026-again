extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func exitGame():
	var fader = create_tween()
	fader.tween_property(self, "modulate:a", 0, 1.0)
	await fader.finished
	queue_free()
