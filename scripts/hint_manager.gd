extends Node

@export var time_threshold: float = 5.5          
@export var mistake_threshold: int = 3           
@export var time_reduction_per_hint: float = 1.5 #NUNCA FOI UTILIZADO

signal hint_triggered(hint_type)

var _time_since_last_action: float = 0.0
var _incorrect_attempts: int = 0
var _current_target: String = ""
var _is_hint_active: bool = false
var _should_process_hints: bool = false

func _ready() -> void:
	_update_processing_flag()

func _process(delta) -> void:
	if not _should_process_hints:
		return
	
	_time_since_last_action += delta
	
	if _should_trigger_time_based_hint():
		_is_hint_active = true
		_trigger_hint("shake")

func _update_processing_flag() -> void:
	_should_process_hints = (
		Globals.show_hints 
		and not Globals.is_paused 
		and Globals.in_game
	)
	
func _should_trigger_time_based_hint() -> bool:
	return (
		_time_since_last_action >= time_threshold 
		and not _is_hint_active
	)
	
func reset_hint_state(target: String) -> void:
	_is_hint_active = false
	_time_since_last_action = 0.0
	_incorrect_attempts = 0
	_current_target = target
	_update_processing_flag()

func register_selection(is_correct: bool) -> void:
	_time_since_last_action = 0.0
	_is_hint_active = false
	
	if is_correct:
		_handle_correct_selection()
	else:
		_handle_incorrect_selection()

func _handle_correct_selection() -> void:
	_incorrect_attempts = 0

func _handle_incorrect_selection() -> void:
	_incorrect_attempts += 1
	
	if _incorrect_attempts >= mistake_threshold:
		_is_hint_active = true
		_trigger_hint("wrong_attempts")

func _trigger_hint(hint_type: String) -> void:
	hint_triggered.emit(hint_type)
