extends GridContainer

func _ready():
	columns = Globals.current_columns
	

		
func setup_grid(items_array: Array, correct_item: String) -> void:	
	clear_grid()
	if Globals.shuffle_grid: items_array = shuffle_items_array(items_array)
	
	for item in items_array:
		var button = TextureButton.new()
		button.texture_normal = load("res://assets/Quadrado Display.png")
		button.custom_minimum_size = Vector2(25, 25)
		button.name = item
		button.pressed.connect(_on_item_selected.bind(item))
		
		var item_texture = TextureRect.new()
		item_texture.texture = load("res://assets/images/%s.png" % item)
		
		item_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		item_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		item_texture.custom_minimum_size = Vector2(85, 85)
		
		item_texture.anchor_left = 0.25
		item_texture.anchor_right = 0.25
		item_texture.anchor_top = 0.25
		item_texture.anchor_bottom = 0.25

		button.add_child(item_texture)
		add_child(button)

func _on_item_selected(selected_item: String) -> void:
	if get_parent().check_selection(selected_item): 
		hide_cell(selected_item)

func clear_grid() -> void:
	var children_to_remove = []
	for child in get_children():
		children_to_remove.append(child)
	
	for child in children_to_remove:
		child.queue_free()
	
	await get_tree().process_frame

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
		

