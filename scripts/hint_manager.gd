extends Node

@export var hint_time_threshold: float = 2.5
@export var hint_missclick_threshold: int = 1
@export var max_wrong_attempts: int = 3  
@export var reduction_time_value: float = 1.5

signal hint_trigger(hint_type)

var time_since_last_selection: float = 0.0
var incorrect_attempts: int = 0
var current_fruit: String = ""
var hint_triggered: bool = false

func _process(delta) -> void:
	if !Globals.show_hints or Globals.is_paused or !Globals.in_game: return #ISSO aqui eh uma bomba, nao mexam nos sinais se nao querem que o mesmo exploda na tua cara
	time_since_last_selection += delta
	if time_since_last_selection >= hint_time_threshold and not hint_triggered:
		hint_triggered = true
		trigger_hint("shake")
		
func trigger_hint(hint_type: String):
	emit_signal("hint_trigger", hint_type)

func reset_hint_state(fruit: String):
	hint_triggered = false
	time_since_last_selection = 0.0
	incorrect_attempts = 0
	current_fruit = fruit

func register_selection(is_correct: bool):
	time_since_last_selection = 0.0
	hint_triggered = false
	if is_correct:
		hint_triggered = false
		incorrect_attempts = 0
	else:
		incorrect_attempts += 1
		if incorrect_attempts >= max_wrong_attempts:
			hint_triggered = true
			trigger_hint("wrong_attempts")
