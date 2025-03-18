extends GridContainer

func _ready():
	columns = Globals.current_columns
	get_viewport().size_changed.connect(_update_grid_layout)
	_update_grid_layout()
	
func _update_grid_layout():
	# Calcular o tamanho adequado para os botões com base no layout atual
	var viewport_size = get_viewport().size
	var available_width = viewport_size.x * 0.6 # 80% da largura da viewport
	var available_height = viewport_size.y * 0.6  # 80% da altura da viewport
	
	# Determinar número de linhas
	var rows = ceil(float(get_child_count()) / columns)
	
	# Calcular tamanho dos botões
	var button_size = min(available_width / columns, available_height / rows) - 10  # -10 para espaçamento
	
	# Atualizar tamanho dos botões e itens internos
	for button in get_children():
		button.custom_minimum_size = Vector2(button_size, button_size)
		
		# Atualizar o item dentro do botão
		if button.get_child_count() > 0:
			var item_texture = button.get_child(0)
			item_texture.custom_minimum_size = Vector2(button_size * 0.6, button_size * 0.6)
			
			# Posicionar o item no centro do botão
			item_texture.anchor_left = 0.5
			item_texture.anchor_top = 0.5
			item_texture.anchor_right = 0.5
			item_texture.anchor_bottom = 0.5
			
			# Ajustar posição considerando as âncoras
			item_texture.position = Vector2(-item_texture.custom_minimum_size.x / 2, -item_texture.custom_minimum_size.y / 2)
	
func _on_hint_triggered(hint_type: String):
	match hint_type:
		"move":
			pass
			#highlight_correct_item()
		"shake":
			pass
			#shake_buttons()
			
func highlight_correct_item(a = null):
	print("destacou")
			
func shake_correct_item(a = null):
	print("chacoalhou")
	
func setup_grid(items_array: Array) -> void:
	clear_grid()
	if get_child_count() == 0:
		if Globals.shuffle_grid: 
			items_array = shuffle_items_array(items_array)
		
		for item in items_array:
			var button = TextureButton.new()
			button.texture_normal = load("res://assets/UI/Quadrado Display.png")
			button.ignore_texture_size = true
			button.stretch_mode = TextureButton.STRETCH_SCALE
			button.custom_minimum_size = Vector2(5, 5)
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
			
			item_texture.texture_filter = TextureRect.TEXTURE_FILTER_LINEAR

			button.add_child(item_texture)
			add_child(button)
	_update_grid_layout()
	
func update_columns(new_columns):
	columns = new_columns
	Globals.current_columns = new_columns
	_update_grid_layout()
	
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
