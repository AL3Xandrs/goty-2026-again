extends CharacterBody2D


var gravity := Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta
	
	move_and_slide()
