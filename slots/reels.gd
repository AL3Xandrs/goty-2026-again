extends Node2D

@export var spin_speed := 750
@export var bias_mult := 1.5
@onready var reels = [$reel1, $reel2, $reel3, $reel4, $reel5]
var symbol_spritesheet = preload("res://assets/slots/symbol_spritesheet.png")

var weights_default = {
	"7":7,
	"Crown":10,
	"clover":14,
	"bell":19,
	"grape":20,
	"lemon":30,
	} #probability of each symbol

var reels_state := []
var final_symbols := []

func _ready() -> void:
	randomize()
	for i in reels:
		reels_state.append(false)

func _process(delta: float) -> void:
	for i in range(0,5):
		if reels_state[i]:
			spin_reel(reels[i],delta)

func _on_play_button_pressed() -> void:
	print(pick_symbol(weights_default))

func _on_bet_1_pressed() -> void:
	for i in range(0,5):
		reels_state[i] = true
		#await get_tree().create_timer(1.5,false).timeout

func pick_symbol(weights:Dictionary):
	var total_weight = 0
	var sum = 0
	
	for entry in weights.values():
		total_weight += entry
	var rng = randi() % total_weight + 1
	
	for i in weights.keys():
		sum +=weights[i]
		if rng < sum:
			return i

func spin_reel(reel:Node2D, delta:float):
	for symbol in reel.get_children():
			symbol.position.y += spin_speed * delta
			if symbol.position.y > 192:
				symbol.position.y -= 488
				var random_symbol = randi_range(0,5)
				
				symbol.frame = randi_range(0,5)

func play():
	for i in range(0,5):
		reels_state[i] = true
	await get_tree().create_timer(1,false).timeout
	
