extends Node

signal start_game


#var music_buttons = {true: preload("res://Sprites/flat-dark/flatDark16.png"), false: preload("res://Sprites/flat-dark/flatDark18.png")}
#var sound_buttons = {true: preload("res://Sprites/flat-dark/flatDark12.png"), false: preload("res://Sprites/flat-dark/flatDark14.png")}
var logger = load("res://scripts/data_collector/logger.gd").get_instance()
var current_screen = null
var timer
var time: float = 0.5
func _ready():
	register_buttons()
	change_screen($Menu)
	print(logger)

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", _on_button_pressed.bind(button))
		#match button.name:
		#	"Sound":
		#		button.texture_normal = sound_buttons[Settings.enable_sound]
		#	"Music":
		#		button.texture_normal = music_buttons[Settings.enable_music]


func _on_button_pressed(button):
	if Globals.enable_sound:
		$ButtonPressed.play()
	match button.name:
		"Start":
			
			$Hud.show()
			change_screen($Game)
			#logger._create_log_entry()
		"Configs":
			$ButtonPressed.play()
			change_screen($Configs) 
		"Data":
			logger.save_logs()
			#change_screen($Data)
		"Home":
			change_screen($Menu) 
			
func change_screen(new_screen):
	if current_screen:
		current_screen.hide()
	current_screen = new_screen
	if new_screen:
		current_screen.show()



