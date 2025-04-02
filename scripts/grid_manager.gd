extends GridContainer

func _ready():
	columns = Globals.current_columns
	get_viewport().size_changed.connect(_update_grid_layout)
	_update_grid_layout()
	
func _update_grid_layout():
	
	var viewport_size = get_viewport().size
	var available_width = viewport_size.x * 0.5 # 80% da largura da viewport
	var available_height = viewport_size.y * 0.5  # 80% da altura da viewport

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

func highlight_correct_item(correct_item: String):
	var button = _find_button_by_name(correct_item)
	if button:
		var tween = create_tween().set_parallel(false)
		var highlight_color = Color(1.2, 1.2, 1.2)  # Brilho branco
		
		tween.tween_property(button, "modulate", highlight_color, 0.15)
		tween.tween_property(button, "modulate", Color.WHITE, 0.15)
		tween.set_loops(3)

func shake_correct_item(correct_item: String):
	const SHAKE_ANGLE: float = 8.0  # Graus de rotação
	const SHAKE_DURATION: float = 0.4
	const SHAKE_FREQUENCY: int = 6
	var button = _find_button_by_name(correct_item)
	if button:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		
		# Padrão de rotação alternada
		var shake_sequence = [
			{"angle": SHAKE_ANGLE, "duration": SHAKE_DURATION/6},   # Direita
			{"angle": -SHAKE_ANGLE * 0.8, "duration": SHAKE_DURATION/5},  # Esquerda
			{"angle": SHAKE_ANGLE * 0.6, "duration": SHAKE_DURATION/4},   # Direita
			{"angle": -SHAKE_ANGLE * 0.4, "duration": SHAKE_DURATION/3},  # Esquerda
			{"angle": 0, "duration": SHAKE_DURATION/2}  # Centralizar
		]
		
		for step in shake_sequence:
			tween.tween_property(button, "rotation_degrees", step.angle, step.duration)
		
		# Garantir reset final
		tween.tween_callback(func():
			if is_instance_valid(button):
				button.rotation_degrees = 0
		)

func _find_button_by_name(item_name: String) -> TextureButton:
	for button in get_children():
		if button.name == item_name:
			return button
	return null
	
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

func shuffle_items_array(items_array: Array) -> Array:
	var shuffled = items_array.duplicate()
	shuffled.shuffle()
	return shuffled
	
"""func hide_cell(cell_name: String) -> void:
	for child in get_children():
		if child.name == cell_name:
			child.modulate = Color(1, 1, 1, 0)
			child.disabled = true"""
