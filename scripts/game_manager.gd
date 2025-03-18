extends Node

var current_item_value: String
var current_item_key: String
var current_item: Array
var matched_items: Array = []
var logger = load("res://scripts/data_collector/logger.gd").get_instance()

var trimmed_dict: Dictionary
var hud
var item

func _ready() -> void:
	hud = get_node("/root/Main/ScreensManager/Hud")
	item = hud.get_node("Control/ItemDisplay/Item")
	$HintManager.connect("hint_trigger", Callable(self, "_on_hint_trigger"))

	reset_game()
	
func _on_hint_trigger(hint_type: String) -> void:
	match hint_type:
		"move":
			print("Dica de movimento ativada")
			$GridManager.highlight_correct_item(current_item_value)
		"shake":
			print("Dica de chacoalhar ativada")
			$GridManager.shake_correct_item(current_item_value)
	
func reset_game() -> void:
	matched_items = []
	trimmed_dict = trim_list()
	$GridManager.setup_grid(trimmed_dict.values())
	select_current_item()
	display_item()

func trim_list() -> Dictionary:
	if Globals.game_mode 	== "Parear": 
		return trim_items_list(Globals.fruit_to_animal)
	elif Globals.game_mode 	== "Associar": 
		return trim_items_list(Globals.item_to_item)
	
	return {}
	
func select_current_item() -> void:
	var attempts = 0
	var max_attempts = trimmed_dict.size() * 2
	
	while attempts < max_attempts:
		current_item = get_random_item()
		current_item_key = current_item[0]
		current_item_value = current_item[1]
		if not matched_items.has(current_item_key):
			$HintManager.reset_hint_state(current_item_key)
			return
		attempts += 1
	reset_game()
	
func display_item() -> void:
	item.set_item_image(current_item_key)
	item.position = Vector2(0,0)

func check_selection(selected_item: String) -> bool:
	var is_correct: bool = false
	if Globals.game_mode == "Parear":
		is_correct = Globals.fruit_to_animal[current_item_key] == selected_item
		if is_correct: 
			trimmed_dict.erase(current_item_key)
			if is_dict_empty():
				reset_game()
			else:
				select_current_item()
				display_item()
			logger.log_correct_answer(selected_item)
	elif Globals.game_mode == "Associar":
		is_correct = Globals.item_to_item[current_item_value] == selected_item
		$HintManager.register_selection(is_correct)
		if is_correct:
			matched_items.append(current_item_value)
			$GridManager.disable_button(selected_item)
			logger.log_correct_answer(selected_item)
			if all_items_matched():
				reset_game()
			else:
				select_current_item()
				display_item()
			logger.log_correct_answer(selected_item)
	return is_correct

func all_items_matched() -> bool:
	return matched_items.size() >= trimmed_dict.size()

func trim_items_list(itens_dict: Dictionary) -> Dictionary:
	var keys_list = itens_dict.keys()
	keys_list.shuffle()
	#MELHORAR ISSO AQUI PARA PEGAR ITENS ALEATORIOS PELA CHAVE
	var selected_keys = keys_list.slice(0, min(Globals.current_columns * Globals.current_rows, keys_list.size()))
	#var selected_keys = keys_list.slice(0, 8)
	var new_dict = {}
	for key in selected_keys:
		new_dict[key] = itens_dict[key]
	return new_dict
	
func is_dict_empty() -> bool:
	return true if trimmed_dict.size() <= 0 else false

func get_random_item() -> Array:
	var keys = trimmed_dict.keys()
	var values = trimmed_dict.values()
	var random = randi() % keys.size()
	return [keys[random], values[random]]

func _exit_tree():
	logger.save_logs()
