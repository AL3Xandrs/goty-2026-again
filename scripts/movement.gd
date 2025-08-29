extends CharacterBody2D


const SPEED = 450.0
var isBusy: bool = 0

@onready var playerSpriteSheet: Sprite2D = $"Icon"

func _physics_process(delta: float) -> void:
	if !isBusy:
		var xDirection := Input.get_axis("ui_left", "ui_right")
		var yDirection := Input.get_axis("ui_up", "ui_down")
		if xDirection > 0:
			playerSpriteSheet.frame = 1
		elif xDirection < 0:
			playerSpriteSheet.frame = 0
		
		if xDirection:
			velocity.x = xDirection * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if yDirection:
			velocity.y = yDirection * SPEED
		else:
			velocity.y = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		#move_and_collide(velocity * delta)
