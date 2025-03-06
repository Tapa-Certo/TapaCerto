extends Sprite2D

func set_fruit_image(fruit_name: String) -> void:
	texture = load("res://assets/images/fruits/%s.png" % fruit_name)
