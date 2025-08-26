extends Node2D

@onready var label := $"./MoneyLabel"
var money: int = 0 : set = setMoney

@onready var blackjack = load("res://blackjack/black_jack_scene.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	money=100
	# var blackJackInstance = blackjack.instantiate()
	# add_child.call_deferred(blackJackInstance)   

func _process(delta: float) -> void:
	pass


func setMoney(value):
	var fancyMoner :Tween = create_tween()
	fancyMoner.tween_method(Callable.create(self, "_updateLabel"), money, value, 0.5)
	money = value

func _updateLabel(value):
	label.text = "$ " + str(value)
