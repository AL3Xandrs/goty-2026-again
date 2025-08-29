extends CharacterBody2D


const SPEED = 450.0
var isBusy: bool = 0
var time: float
var frameInterval: float = 0.2
@onready var playerSpriteSheet: Sprite2D = $"Icon"

func _physics_process(delta: float) -> void:
	if !isBusy:
		time += delta
		var xDirection := Input.get_axis("ui_left", "ui_right")
		var yDirection := Input.get_axis("ui_up", "ui_down")
		
		if xDirection > 0:
			if playerSpriteSheet.frame % 2 == 0:
				playerSpriteSheet.frame += 1
			if time > frameInterval:
				if playerSpriteSheet.frame != 3:
					playerSpriteSheet.frame = 3
				else:
					playerSpriteSheet.frame = 5
		elif xDirection < 0:
			if playerSpriteSheet.frame % 2 == 1:
				playerSpriteSheet.frame -= 1
			if time > frameInterval:
				if playerSpriteSheet.frame != 2:
					playerSpriteSheet.frame = 2
				else:
					playerSpriteSheet.frame = 4
		if time > frameInterval:
			time = 0
		if xDirection == 0:
			playerSpriteSheet.frame = playerSpriteSheet.frame % 2
		# Petre, daca vezi aceasta parte din cod si decizi sa comentezi cu privire la
		# decizia de a face animation cycle-ul asa, te rog sa asculti sfatul lui
		# zeu de rang jos
		
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
