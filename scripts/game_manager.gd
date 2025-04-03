extends Node

signal item_selected(key: String, value: String)
signal game_reset_requested
signal all_items_matched

@onready var hud: Node = get_node("/root/Main/ScreensManager/Hud")
@onready var item: Node = hud.get_node("Control/ItemDisplay/Item")
@onready var logger: Node = load("res://scripts/data_collector/logger.gd").get_instance()

# Game State Variables
var current_item_key: String
var current_item_value: String
var matched_items: Array = []
var available_items: Dictionary = {}
#var total_items : itens = 

#ta usando isso aqui???
var animal_sounds = {
	"macaco": $macaco,
	"cavalo": $cavalo,
	"elefante": $elefante,
	"girafa": $girafa,
	"peixe": $peixe,
	"leao": $leao,
	"coelho": $coelho,
	"abelha": $abelha,
	"pinguim": $pinguim,
	"porco": $porco,
	"vaca": $vaca,
	"urso": $urso,
	"galinha": $galinha,
	"gato": $gato,
	"cachorro": $cachorro,
	"esquilo": $esquilo
}

func _ready() -> void:

	_setup_global_signals()
	_setup_children_signals()

func _setup_global_signals() -> void:
	Globals.game_started.connect(_on_game_started)
	Globals.game_reset.connect(_on_game_reset)
	#Globals.difficulty_changed.connect(_on_difficulty_changed)
	#Globals.game_mode_changed.connect(_on_game_mode_changed)

func _setup_children_signals() -> void:
	$HintManager.hint_triggered.connect(_on_hint_trigger)
	
func _on_hint_trigger(hint_type: String) -> void:
	match hint_type:
		"wrong_attempts":
			$GridManager.highlight_correct_item(current_item_value)
		"shake":
			if Globals.game_mode == "Associar":
				var sound_node = get_animal_sound(current_item_value)
				if sound_node: sound_node.play()
			if Globals.game_mode == "Parear":
				$Shake.play()
			$GridManager.shake_correct_item(current_item_value)
	$HintManager.reset_hint_state(current_item_key)

func get_animal_sound(animal: String) -> AudioStreamPlayer2D:
	return get_node_or_null("Animais/" + animal)
	
func _on_game_started() -> void:
	_prepare_available_items()
	$GridManager.setup_grid(available_items.values())
	_select_and_display_current_item()

func _on_game_reset() -> void:
	matched_items.clear()
	_prepare_available_items()

func _on_difficulty_changed(_new_difficulty: String) -> void:
	pass
	#reset_game()

func _on_game_mode_changed(_new_mode: String) -> void:
	pass
	#reset_game()

func reset_game() -> void:
	matched_items.clear()
	_prepare_available_items()
	$GridManager.setup_grid(available_items.values())
	_select_and_display_current_item()

func _prepare_available_items() -> void:
	match Globals.game_mode:
		"Parear": 
			available_items = _select_random_items(Globals.item_to_item)
		"Associar": 
			available_items = _select_random_items(Globals.item_to_animal)
		_:
			available_items = {}

func _select_random_items(source_dict: Dictionary) -> Dictionary:
	var keys_list = source_dict.keys()
	keys_list.shuffle()
	
	var items_to_select = min(Globals.current_columns * Globals.current_rows, keys_list.size())
	var selected_keys = keys_list.slice(0, items_to_select)
	
	var result_dict = {}
	for key in selected_keys:
		result_dict[key] = source_dict[key]
	
	return result_dict

func _select_and_display_current_item() -> void:
	if available_items.is_empty():
		game_reset_requested.emit()
		return
		
	var unmatched_items = _get_unmatched_items()
	if unmatched_items.is_empty():
		all_items_matched.emit()
		return
	
	var random_index = randi() % unmatched_items.size()
	var item_pair = unmatched_items[random_index]

	current_item_key = item_pair[0]
	current_item_value = item_pair[1]
	$HintManager.reset_hint_state(current_item_key)
	
	display_item()
	item_selected.emit(current_item_key, current_item_value)

func _get_unmatched_items() -> Array:
	var unmatched = []
	for key in available_items:
		if not matched_items.has(key):
			unmatched.append([key, available_items[key]])
	
	return unmatched
	
func display_item() -> void:
	item.set_item_image(current_item_key)
	item.position = Vector2(0,0)

func check_selection(selected_item: String) -> bool:
	var is_correct := _is_selection_correct(selected_item)
	_handle_selection_feedback(is_correct, selected_item)
	
	if is_correct:
		_handle_correct_selection(selected_item)
	else:
		_handle_incorrect_selection()
	
	return is_correct

func _is_selection_correct(selected_item: String) -> bool:
	match Globals.game_mode:
		"Parear":
			return current_item_key == selected_item
		"Associar":
			return available_items[current_item_key] == selected_item
		_:
			return false

func _handle_selection_feedback(is_correct: bool, selected_item: String) -> void:
	$HintManager.register_selection(is_correct)
	var node: Node = null
	if Globals.game_mode == "Parear":
		node = get_node_or_null("Animais/" + current_item_key)
	else:
		node = get_node_or_null("Animais/" + selected_item)
	if node:
		node.stop()
	

func _handle_correct_selection(selected_item: String) -> void:
	$Correct.play()
	matched_items.append(current_item_key)
	$GridManager.disable_button(selected_item)
	logger.log_correct_answer(selected_item)
	
	if is_all_items_matched():
		all_items_matched.emit()
	else:
		_select_and_display_current_item()

func _handle_incorrect_selection() -> void:
	$Incorrect.play()
	logger.log_incorrect_answer()

func is_all_items_matched() -> bool:
	Globals.numberOfCurrect += 1
	checkIfWin(Globals.numberOfCurrect)
	return matched_items.size() >= available_items.size()
	
func _play_animal_sound(animal: String) -> void:
	var sound_node = get_node_or_null("Animais/" + animal)
	if sound_node:
		sound_node.play()

func checkIfWin(numberOfCurrect: int) -> bool: 
	if numberOfCurrect == Globals.numberOfItens: 
		$"..".change_screen($"../WinScene")
		return true
	return false

func _exit_tree():
	#logger.save_logs()
	logger.get_instance().save_logs()
