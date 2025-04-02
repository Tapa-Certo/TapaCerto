extends Node

signal start_game

var logger = load("res://scripts/data_collector/logger.gd").get_instance()
var current_screen = null
var previous_screen = null  # Armazena a tela anterior
var timer
var time: float = 0.5

func _ready():
	register_buttons()
	change_screen($Menu)

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", _on_button_pressed.bind(button))

func _on_button_pressed(button):
	if Globals.enable_sound:
		$ButtonPressed.play()
		
	match button.name:
		"Start":
			Globals.start_game()
			$Hud.show()
			change_screen($Game)

		"Configs":
			# Salva a tela atual antes de mudar para configurações
			previous_screen = current_screen
			Globals.pause_game()
			$ButtonPressed.play()
			Globals.in_game = false
			$Game/HintManager.update_processing_flag()
			change_screen($Configs) 

		"Back":
			if previous_screen:
				change_screen(previous_screen)
				if previous_screen == $Game:
					Globals.resume_game() 
					Globals.in_game = true
					$Game/HintManager.update_processing_flag()
				else:
					Globals.in_game = false

		"Data":
			logger.save_logs()

		"Home":
			Globals.reset_game()
			Globals.in_game = false
			$Game/HintManager.update_processing_flag()
			change_screen($Menu) 

func change_screen(new_screen):
	if current_screen:
		current_screen.hide()
	current_screen = new_screen
	if new_screen:
		current_screen.show()
