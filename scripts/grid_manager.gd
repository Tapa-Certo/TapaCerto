extends GridContainer

func _ready():
	columns = Globals.current_columns
	
"""func setup_grid(items_array: Array, correct_item: String) -> void:	
	clear_grid()
	if Globals.shuffle_grid: items_array = shuffle_items_array(items_array)
	
	for item in items_array:
		var button = TextureButton.new()
		button.texture_normal = load("res://assets/Quadrado Display.png")
		button.custom_minimum_size = Vector2(45, 45)
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
		add_child(button)"""
		
func setup_grid(items_array: Array) -> void:
	clear_grid()
	if get_child_count() == 0:
		if Globals.shuffle_grid: 
			items_array = shuffle_items_array(items_array)
		
		for item in items_array:
			var button = TextureButton.new()
			button.texture_normal = load("res://assets/UI/Quadrado Display.png")
			button.custom_minimum_size = Vector2(45, 45)
			button.name = item
			button.pressed.connect(_on_item_selected.bind(item))
			
			var item_texture = TextureRect.new()
			item_texture.texture = load("res://assets/images/%s.png" % item)
			
			item_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			item_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			item_texture.custom_minimum_size = Globals.item_size
			
			item_texture.anchor_left = 0.25
			item_texture.anchor_right = 0.25
			item_texture.anchor_top = 0.25
			item_texture.anchor_bottom = 0.25

			button.add_child(item_texture)
			add_child(button)

func disable_button(item_name: String) -> void:
	for button in get_children():
		if button.name == item_name:
			var item_texture = button.get_child(0)
			item_texture.modulate = Globals.items_oppacity
			button.disabled = true
			break
			
func _on_item_selected(selected_item: String) -> void:
	get_parent().check_selection(selected_item)

func clear_grid() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	get_children().clear()

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
		

