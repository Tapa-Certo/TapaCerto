extends TextureRect

@export var custom_size = Vector2(50, 50)

func set_item_image(item_name: String) -> void:
	print(item_name)
	texture = load("res://assets/images/%s.png" % item_name)
	
	var texture_size = texture.get_size()
	scale = Vector2(
		custom_size.x / texture_size.x,
		custom_size.y / texture_size.y
	)
	position = Vector2(0,0)
