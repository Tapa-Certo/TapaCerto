extends Node

var fruit_to_animal: Dictionary = {
	"banana": "macaco",
	"maca": "cavalo",
	"amendoim": "elefante",
	"arvore": "girafa",
	"aquario": "peixe",
	"carne": "leao",
	"cenoura": "coelho",
	"flor": "abelha",
	"gelo": "pinguim",
	"lama": "porco",
	"leite": "vaca",
	"mel": "urso",
	"milho": "galinha",
	"novelo": "gato",
	"osso": "cachorro",
	"noz": "esquilo"
}

var fruit_to_fruit: Dictionary = {
	"banana": "banana",
	"maca": "maca",
	"amendoim": "amendoim",
	"arvore": "arvore",
	"aquario": "aquario",
	"carne": "carne",
	"cenoura": "cenoura",
	"flor": "flor",
	"gelo": "gelo",
	"lama": "lama",
	"leite": "leite",
	"mel": "mel",
	"milho": "milho",
	"novelo": "novelo",
	"osso": "osso",
	"noz": "noz"
}

var animal_to_animal: Dictionary = {
	"macaco": "macaco",
	"cavalo": "cavalo",
	"elefante": "elefante",
	"girafa": "girafa",
	"peixe": "peixe",
	"leao": "leao",
	"coelho": "coelho",
	"abelha": "abelha",
	"pinguim": "pinguim",
	"porco": "porco",
	"vaca": "vaca",
	"urso": "urso",
	"galinha": "galinha",
	"gato": "gato",
	"cachorro": "cachorro",
	"esquilo": "esquilo"
}

var item_to_item: Dictionary = {
	"macaco": "macaco",
	"cavalo": "cavalo",
	"elefante": "elefante",
	"girafa": "girafa",
	"peixe": "peixe",
	"leao": "leao",
	"coelho": "coelho",
	"abelha": "abelha",
	"pinguim": "pinguim",
	"porco": "porco",
	"vaca": "vaca",
	"urso": "urso",
	"galinha": "galinha",
	"gato": "gato",
	"cachorro": "cachorro",
	"esquilo": "esquilo",
	"banana": "banana",
	"maca": "maca",
	"amendoim": "amendoim",
	"arvore": "arvore",
	"aquario": "aquario",
	"carne": "carne",
	"cenoura": "cenoura",
	"flor": "flor",
	"gelo": "gelo",
	"lama": "lama",
	"leite": "leite",
	"mel": "mel",
	"milho": "milho",
	"novelo": "novelo",
	"osso": "osso",
	"noz": "noz"
}

var itens_array: Array = [
	"macaco", "cavalo", "elefante", "girafa", "peixe",
	"leao", "coelho", "abelha", "pinguim", "porco", 
	"vaca", "urso", "galinha", "gato", "cachorro", "esquilo",
	"banana", "maca", "amendoim", "arvore", "aquario",
	"carne", "cenoura", "flor", "gelo", "lama",
	"leite", "mel", "milho", "novelo", "osso", "noz"
	]

#MUDAR ISSO AQUI PARA PEGAR ITEM ALEATORIO DE LISTA JA TRIMADA
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
	reset_game()
	
func reset_game() -> void:
	matched_items = []
	trimmed_dict = trim_list()
	$GridManager.setup_grid(trimmed_dict.values())
	select_current_item()
	display_item()
	#display_buttons()

func trim_list() -> Dictionary:
	if Globals.game_mode 	== "Parear": 
		return trim_items_list(fruit_to_animal)
	elif Globals.game_mode 	== "Associar": 
		return trim_items_list(item_to_item)
	
	return {}
	
func select_current_item() -> void:
	var attempts = 0
	var max_attempts = trimmed_dict.size() * 2
	
	while attempts < max_attempts:
		current_item = get_random_item()
		current_item_key = current_item[0]
		current_item_value = current_item[1]
		if not matched_items.has(current_item_key):
			return
		attempts += 1
	reset_game()
	
func display_item() -> void:
	item.set_item_image(current_item_key)
	item.position = Vector2(0,0)

"""func display_buttons():
	if Globals.game_mode 	== "Parear": 
		$GridManager.setup_grid(trimmed_dict.values(), current_item_value)
	elif Globals.game_mode 	== "Associar": 
		$GridManager.setup_grid(trimmed_dict.values(), current_item_value)"""
	
func check_selection(selected_item: String) -> bool:
	var is_correct: bool = false
	if Globals.game_mode == "Parear":
		is_correct = fruit_to_animal[current_item_key] == selected_item
		if is_correct: 
			#TEM QUE MUDAR ISSO AQUI PARA NAO APAGAR DA LISTA
			trimmed_dict.erase(current_item_key)
			if is_dict_empty():
				reset_game()
			else:
				select_current_item()
				display_item()
				#display_buttons()
			logger.log_correct_answer(selected_item)
	elif Globals.game_mode == "Associar":
		is_correct = item_to_item[current_item_value] == selected_item
		if is_correct:
			matched_items.append(current_item_value)
			$GridManager.disable_button(selected_item)
			logger.log_correct_answer(selected_item)
			if all_items_matched():
				reset_game()
			else:
				select_current_item()
				display_item()
				#display_buttons()
			logger.log_correct_answer(selected_item)
	return is_correct

func all_items_matched() -> bool:
	return matched_items.size() >= trimmed_dict.size()

func trim_items_list(itens_dict: Dictionary) -> Dictionary:
	var keys_list = itens_dict.keys()
	keys_list.shuffle()
	#MELHORAR ISSO AQUI PARA PEGAR ITENS ALEATORIOS PELA CHAVE
	#var selected_keys = keys_list.slice(0, min(Globals.current_columns * Globals.current_rows, keys_list.size()))
	var selected_keys = keys_list.slice(0, 8)
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

#func set_fruit_image(fruit: String) -> void:
	#$Fruit.set_fruit_image(current_fruit)
#func set_animal_image(animals_values_array: Array, current_animal: String) -> void:
	#$AnimalsManager.set_animal_buttons(animals_values_array, current_animal)
