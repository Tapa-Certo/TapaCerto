extends Sprite2D

@export var custom_size = Vector2(100, 100)

func set_item_image(item_name: String) -> void:
	texture = load("res://assets/images/%s.png" % item_name)

	var texture_size = texture.get_size()
	scale = Vector2(
		custom_size.x / texture_size.x,
		custom_size.y / texture_size.y
	)
