extends Node2D

@onready var ball = $"Wheel/RouletteBall"
@onready var wheel = $"Wheel/WheelSprite"
@onready var roulette = $Wheel
@onready var green =$"Wheel/WheelSprite/Area2D"

@onready var blackjackEnding:= $BlackjackWinEnding
@onready var barbutEnding:= $PayRentEnding
@onready var slotEnding:= $SlotWinEnding
@onready var falitEnding:=$NoMoneyEnding
@onready var jumpscareEnding:=$LandlordEnding
@onready var finaleEnding:= $TheHouseAlwaysWins

@onready var buttons = $"Wheel/Buttons"

var chosenScreen
var spinning:bool = 1


signal done
signal start


var type: String = "Finale"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	match type:
		"Finale": chosenScreen=finaleEnding;roulette.modulate.a = 0; roulette.show() ; await runFinale()
		"Pussy 1": chosenScreen = barbutEnding
		"Pussy 2": chosenScreen = blackjackEnding
		"Pussy 4": chosenScreen = slotEnding   # ba care va uitati pe-aci sa nu ma contactati ca nu repar nmk
											   # daca vine vorba, asta e 4 si nu 3 din cauza la fuckass pacanele
		"Bankrupt": chosenScreen = falitEnding
		"Jumpscare": chosenScreen = jumpscareEnding
	
	await drawScreen()
	print("a")
	emit_signal("done")

func runFinale():
	var fader = create_tween()
	fader.tween_property(roulette, "modulate:a", 1, 2)
	await fader.finished
	await start
	$"./Wheel/WheelSprite/Area2D/CollisionShape2D".disabled = 0
	buttons.hide()
	
	var spinner = create_tween()
	spinner.tween_property(wheel,"rotation", 35, 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	spinner.tween_property(wheel,"rotation", 70, 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(3, false).timeout
	ball.velocity = Vector2(-45, -200)
	ball.gravity = Vector2(0, 100)
	
	await spinner.finished
	
	await get_tree().create_timer(1, false).timeout
	spinning = false
	
	var fader2 = create_tween()
	fader2.tween_property(roulette, "modulate:a", 0, 2)
	await fader2.finished


func _onBodyEnterGreen(body: Node2D) -> void: 
	if chosenScreen==finaleEnding:
		body.velocity = Vector2(0, 0)
		body.gravity = Vector2(0, 0)
		while(spinning):
			green.add_child.call
			body.global_position = green.global_position
			await get_tree().create_timer(0.01, false).timeout # yeah, I know

func drawScreen():
	chosenScreen.modulate.a = 0
	chosenScreen.show()
	var fader = create_tween()
	fader.tween_property(chosenScreen, "modulate:a", 1, 3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	fader.tween_property(chosenScreen, "modulate:a", 0, 3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	
	await fader.finished


func _onPressButton(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("start")
