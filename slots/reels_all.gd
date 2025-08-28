extends Node2D

@export var bias_mult := 1
@onready var reels = [$reel1, $reel2, $reel3, $reel4, $reel5]
var is_spinning = false

#var weights_default = {
	#"7":7,
	#"Crown":10,
	#"clover":14,
	#"bell":19,
	#"grape":20,
	#"melon":20,
	#"lemon":30,
	#"cherry":30,
	#} #old probability

var weights_default = {
	"7":4,
	"Crown":6,
	"clover":9,
	"bell":11,
	"grape":13,
	"melon":15,
	"lemon":24,
	"cherry":18,
	} #probability of each symbol

var multiplier_table = {
	"7":[0,0,1,5,25,500],
	"Crown":[0,0,0,4,12,70],
	"clover":[0,0,0,4,12,70],
	"bell":11,
	"grape":13,
	"melon":15,
	"lemon":24,
	"cherry":18,
	}


var final_symbols := []

func _ready() -> void:
	randomize()
	for i in range(5):
		reels[i].index = i

func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	play()

func _on_bet_1_pressed() -> void:
	pass

func pick_symbol(weights:Dictionary):
	var total_weight = 0
	var sum = 0
	
	for entry in weights.values():
		total_weight += entry
	var rng = randi() % int(total_weight) + 1
	
	for i in weights.keys():
		sum +=weights[i]
		if rng <= sum:
			return i

func calc_tablou():
	var unbiased := true
	var final_symbols2 := [] #variabila asta e doar o copie sa o pot returna in play
	var weights :Dictionary
	for r in range(5):
		final_symbols2.append(["1","2","3",null])
		
	for i in range(5):
		for j in range(3):
			weights = weights_default.duplicate()
			if(unbiased == false):
				var prev_symbol = final_symbols2[i-1][j] #stanga
				weights[prev_symbol] *= (1.0 + bias_mult)
				
				prev_symbol = final_symbols2[i-1][j-1] #stanga sus
				if prev_symbol != null:
					weights[prev_symbol] *= (1.0 + bias_mult)
				
				prev_symbol = final_symbols2[i-1][j+1] #stanga jos
				if prev_symbol != null:
					weights[prev_symbol] *= (1.0 + bias_mult)
			
			final_symbols2[i][j] = pick_symbol(weights)
		unbiased = false
	return final_symbols2

func play():
	if !is_spinning:
		is_spinning = true
		final_symbols = calc_tablou()
		for r in range(5):
			reels[r].spin(final_symbols[r])
		await get_tree().create_timer(2.4,false).timeout
		is_spinning = false
	
	
	
	
