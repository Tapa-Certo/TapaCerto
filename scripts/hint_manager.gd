extends Node

@export var time_threshold: float = 5.5
@export var mistake_threshold: int = 3
@export var time_reduction_per_hint: float = 1.5 # NUNCA FOI UTILIZADO
signal hint_triggered(hint_type)

var time_since_last_action: float = 0.0
var incorrect_attempts: int = 0
var current_target: String = ""
var is_hint_active: bool = false
var should_process_hints: bool = false

func _ready() -> void:
	update_processing_flag()
	# Opcional: Conectar a um sinal global de mudança de estado, se existir
	# Exemplo: Globals.connect("in_game_changed", self, "_on_in_game_changed")

func _process(delta) -> void:
	if not should_process_hints:
		return
	
	time_since_last_action += delta
	
	if should_trigger_time_based_hint():
		is_hint_active = true
		trigger_hint("shake")

func update_processing_flag() -> void:
	should_process_hints = (Globals.show_hints and Globals.in_game)
	set_process(should_process_hints)  # Pausa o _process se não deve processar
	print("Atualizando hints: in_game =", Globals.in_game, "should_process_hints =", should_process_hints)
	if should_process_hints:
		time_since_last_action = 0.0
		is_hint_active = false

func should_trigger_time_based_hint() -> bool:
	return (
		time_since_last_action >= time_threshold 
		and not is_hint_active
	)

func reset_hint_state(target: String) -> void:
	is_hint_active = false
	time_since_last_action = 0.0
	incorrect_attempts = 0
	current_target = target
	update_processing_flag()

func register_selection(is_correct: bool) -> void:
	time_since_last_action = 0.0
	is_hint_active = false
	
	if is_correct:
		handle_correct_selection()
	else:
		handle_incorrect_selection()

func handle_correct_selection() -> void:
	incorrect_attempts = 0

func handle_incorrect_selection() -> void:
	incorrect_attempts += 1
	
	if incorrect_attempts >= mistake_threshold:
		is_hint_active = true
		trigger_hint("wrong_attempts")

func trigger_hint(hint_type: String) -> void:
	hint_triggered.emit(hint_type)

# Função para reagir a mudanças em Globals.in_game (se houver um sinal)
func _on_in_game_changed(new_value: bool) -> void:
	update_processing_flag()
