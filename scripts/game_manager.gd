extends Node

var fruit_to_animal: Dictionary = {
	"banana": "macaco",
	"maca": "cavalo"
}
var current_fruit: String = ""
var logger = preload("res://scripts/data_collector/logger.gd").get_instance()

func _ready() -> void:
	$HintManager.hint_trigger.connect(hint_animation)
	show_new_fruit()

func hint_animation(hint_type: String):
	match hint_type:
		"move": $AnimalsManager.animate_correct_animal(fruit_to_animal[current_fruit])
		"wrong_attemps": $AnimalsManager.highlight_correct_animal(fruit_to_animal[current_fruit])

func show_new_fruit() -> void:
	var fruits_keys_list = fruit_to_animal.keys()
	current_fruit = random_fruit(fruits_keys_list)
	$Fruit.set_fruit_image(current_fruit)
	$AnimalsManager.set_animal_buttons(fruit_to_animal.values(), fruit_to_animal[current_fruit])
	$HintManager.reset_hint_state(current_fruit)
	
func check_selection(selected_animal: String) -> bool:
	var is_correct = fruit_to_animal[current_fruit] == selected_animal
	$HintManager.register_selection(is_correct)
	if is_correct:
		show_new_fruit()
	return is_correct

func random_fruit(fruits_list: Array) -> String:
	return fruits_list[randi() % fruits_list.size()]

func set_fruit_image(fruit: String) -> void:
	$Fruit.set_fruit_image(current_fruit)

func set_animal_image(animals_values_array: Array, current_animal: String) -> void:
	$AnimalsManager.set_animal_buttons(animals_values_array, current_animal)


func _exit_tree():
	logger.save_logs()
