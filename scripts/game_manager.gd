extends Node

var current_item_key: String
var current_item_value: String

var matched_items: Array = []
var available_items: Dictionary = {}

var hud
var item
var logger = load("res://scripts/data_collector/logger.gd").get_instance()

func _ready() -> void:
	hud = get_node("/root/Main/ScreensManager/Hud")
	item = hud.get_node("Control/ItemDisplay/Item")
	$HintManager.connect("hint_trigger", Callable(self, "_on_hint_trigger"))

	reset_game()
	
func _on_hint_trigger(hint_type: String) -> void:
	match hint_type:
		"wrong_attempts":
			print("Dica de movimento ativada")
			$GridManager.highlight_correct_item(current_item_value)
			
		"shake":
			print("Dica de chacoalhar ativada")
			$GridManager.shake_correct_item(current_item_value)
	$HintManager.reset_hint_state(current_item_key)
func reset_game() -> void:
	matched_items.clear()
	_prepare_available_items()
	$GridManager.setup_grid(available_items.values())
	select_current_item()
	display_item()
	emit_signal("game_reset")

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

func select_current_item() -> void:
	if available_items.is_empty():
		reset_game()
		return
		
	var unmatched_items = _get_unmatched_items()
	if unmatched_items.is_empty():
		reset_game()
		return
	
	var random_index = randi() % unmatched_items.size()
	var item_pair = unmatched_items[random_index]

	current_item_key = item_pair[0]
	current_item_value = item_pair[1]
	$HintManager.reset_hint_state(current_item_key)

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
	var is_correct: bool = false

	match Globals.game_mode:
		"Parear": 
			is_correct = available_items[current_item_value] == selected_item
		"Associar": 
			is_correct = available_items[current_item_key] == selected_item
	
	$HintManager.register_selection(is_correct)
	
	if is_correct:
		matched_items.append(current_item_key)
		$GridManager.disable_button(selected_item)
		
		if all_items_matched():
			reset_game()
		else:
			select_current_item()
			display_item()
		#logger.log_correct_answer(selected_item)
		logger.get_instance().log_correct_answer(selected_item)
	else: 
		logger.get_instance().log_incorrect_answer()
	
	return is_correct

func all_items_matched() -> bool:
	return matched_items.size() >= available_items.size()

func _exit_tree():
	#logger.save_logs()
	logger.get_instance().save_logs()
