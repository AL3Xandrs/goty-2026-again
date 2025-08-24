extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	var xDirection := Input.get_axis("ui_left", "ui_right")
	var yDirection := Input.get_axis("ui_up", "ui_down")
	
	if xDirection:
		velocity.x = xDirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if yDirection:
		velocity.y = yDirection * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_collide(velocity * delta)
