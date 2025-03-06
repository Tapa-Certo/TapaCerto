extends GridContainer

func _ready():
	columns = Globals.current_columns
	
func setup_grid(items_array: Array, correct_item: String) -> void:
	clear_grid()
	if Globals.shuffle_grid: items_array = shuffle_items_array(items_array)
	
	for item in items_array:
		var button = Button.new()
		button.text = ""
		#button.icon = load("res://assets/images/%s/%s.png" % [get_item_type(item), item])
		button.icon = load("res://assets/images/%s.png" % item)
		button.expand_icon = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.pressed.connect(_on_item_selected.bind(item))
		button.custom_minimum_size = Vector2(75, 75)
		button.name = item
		add_child(button)

func _on_item_selected(selected_item: String) -> void:
	if get_parent().check_selection(selected_item): 
		hide_cell(selected_item)

func clear_grid() -> void:
	for child in get_children():
		print(child)
		child.queue_free()
		
func hide_cell(cell_name: String) -> void:
	for child in get_children():
		if child.name == cell_name:
			child.modulate = Color(1, 1, 1, 0)
			child.disabled = true

func shuffle_items_array(items_array: Array) -> Array:
	var shuffled = items_array.duplicate()
	shuffled.shuffle()
	return shuffled

#func get_item_type(item: String) -> String:
	#if item in Globals.fruit_to_animal.keys():
		#return "fruits"
	#else:
		#return "animals"
		

