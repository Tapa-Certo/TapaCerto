extends Node

@export var hint_time_threshold: float = 10.0
@export var hint_missclick_threshold: int = 3
@export var max_wrong_attempts: int = 3  
@export var reduction_time_value: float = 1.5

signal hint_trigger(hint_type)

var time_since_last_selection: float = 0.0
var incorrect_attempts: int = 0
var current_fruit: String = ""
var hint_triggered: bool = false
	
func _process(delta) -> void:
	if !Globals.show_hints: return
	time_since_last_selection += delta
	if time_since_last_selection >= hint_time_threshold and not hint_triggered:
		trigger_hint("move")
		hint_triggered = true
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
	if not is_correct:
		incorrect_attempts += 1
		if incorrect_attempts >= hint_missclick_threshold:
			trigger_hint("wrong_attemps")
