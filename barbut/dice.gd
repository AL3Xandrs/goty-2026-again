class_name Dice
extends CharacterBody2D

var value: int
var source: Vector2
var target: Vector2

var speed: float = 1000
var friction: float = 0.95
var isStopped: bool = 0
@onready var diceSprite:Sprite2D = $"./DiceSheet" 
@onready var hitbox:= $"./CollisionShape2D"

func _ready() -> void:
	position = source
	scale = Vector2(2, 2)
	velocity = (target - source).normalized().rotated(deg_to_rad(randi_range(-20, 20))) * randi_range(speed-250, speed+250)
	doFunnyRoll()

func _physics_process(delta: float) -> void:
	if velocity.length() > 5:
		var collision = move_and_collide(velocity * delta)
		if collision: 
			velocity = velocity.bounce(collision.get_normal())
		velocity *= friction
		if velocity.length() < 100:
			isStopped = 1

func clearDie():
	hitbox.disabled = true
	var fader = create_tween()
	fader.tween_property(self, "modulate:a", 0, 0.5)
	await fader.finished
	queue_free()

func doFunnyRoll():
	for i in range(10):
		diceSprite.region_rect.position = Vector2(randi_range(0,5)*64, 0)
		await get_tree().create_timer(0.08, false).timeout
	diceSprite.region_rect.position = Vector2((value-1)*64, 0)
