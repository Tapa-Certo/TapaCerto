extends GridContainer

var animals_array: Array = []
func _ready():
	columns = 5
	
func set_animal_buttons(animals_array: Array, correct_animal: String):
	clear_grid()
	if Globals.shuffle_animals:
		animals_array = shuffle_animals_array(animals_array)
		
	for animal in animals_array:
		var button = Button.new()
		button.text = ""
		button.icon = load("res://assets/images/animals/%s.png" % animal)
		button.expand_icon = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.pressed.connect(_on_animal_selected.bind(animal))
		button.custom_minimum_size = Vector2(75, 75)
		add_child(button)

func _on_animal_selected(selected_animal: String):
	get_parent().check_selection(selected_animal)

func clear_grid() -> void:
	for child in get_children():
		child.queue_free()

func shuffle_animals_array(animals_array: Array) -> Array:
	var shuffled = animals_array.duplicate()
	shuffled.shuffle() 
	return shuffled
