extends TextureRect

func set_item_image(item_name: String) -> void:
	texture = load("res://assets/images/%s.png" % item_name)
	
	var texture_size = texture.get_size()
	scale = Vector2(
		Globals.item_size.x / texture_size.x,
		Globals.item_size.y / texture_size.y
	)
	await get_tree().process_frame 

	position = (get_parent().size / 2) - (Globals.item_size / 2)
