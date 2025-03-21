extends Node

@export var hint_time_threshold: float = 2.5
@export var hint_missclick_threshold: int = 1
@export var max_wrong_attempts: int = 3  
@export var reduction_time_value: float = 1.5

signal hint_trigger(hint_type)

	
func _process(delta) -> void:
	if !Globals.show_hints: return
	Globals.time_since_last_selection += delta
	if Globals.time_since_last_selection >= hint_time_threshold and not Globals.hint_triggered:
		trigger_hint("shake")
		Globals.hint_triggered = true
func trigger_hint(hint_type: String):
	emit_signal("hint_trigger", hint_type)

func reset_hint_state(fruit: String):
	Globals.hint_triggered = false
	Globals.time_since_last_selection = 0.0
	Globals.incorrect_attempts = 0
	Globals.current_fruit = fruit
	
func register_selection(is_correct: bool):
	Globals.time_since_last_selection = 0.0
	Globals.hint_triggered = false
	if is_correct:
		Globals.hint_triggered = false
		Globals.incorrect_attempts = 0
	else:
		Globals.incorrect_attempts += 1
		if Globals.incorrect_attempts >= max_wrong_attempts:
			trigger_hint("wrong_attempts")
			Globals.hint_triggered = true
