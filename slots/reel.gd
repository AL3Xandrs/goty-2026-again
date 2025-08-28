extends Node2D

@onready var symbols = [$dummy, $symbol1, $symbol2, $symbol3]
var index :int

var name_to_sprite = {
	"7":0,
	"Crown":1,
	"clover":2,
	"bell":3,
	"grape":4,
	"lemon":5,
	"cherry":6,
	"melon":7,
}

func _ready() -> void:
	pass

func spin_mini(frame:int):
	var pos = [symbols[0].position, symbols[1].position, symbols[2].position, symbols[3].position]
	var last
	for i in range(4):
		var mover = create_tween()
		mover.tween_property(symbols[i],"position",pos[i] + Vector2(0,128),0.1)
		if symbols[i].position > Vector2(0,127):
			last = symbols[i]
	await get_tree().create_timer(0.11,false).timeout
	last.position = Vector2(0,-256)
	last.frame = frame

func spin(final_symbols:Array):
	for i in range((3 + index) * 4):
		await spin_mini(randi_range(0,7))
	for i in range(2,-1,-1):
		await spin_mini(name_to_sprite[final_symbols[i]])
		
	await spin_mini(randi_range(0,5))
	var rubber_band = create_tween()
	var initial_position = position # this variable stores the position of the bottom symbol before the rubber band effect starts. This helps avoid a very unvofortunate bug that cumulates the bounce back
	rubber_band.tween_property(self,"position",initial_position + Vector2(0,20), 0.25)
	rubber_band.tween_property(self,"position",initial_position, 0.35).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
