extends CanvasLayer

func _on_audio_on_pressed():
	$Panel/MarginContainer/PanelContainer/Control/audio_on.hide()
	$Panel/MarginContainer/PanelContainer/Control/audio_off.show()
	toggle_audio()

func _on_audio_off_pressed():
	$Panel/MarginContainer/PanelContainer/Control/audio_on.show()
	$Panel/MarginContainer/PanelContainer/Control/audio_off.hide()
	toggle_audio()

func toggle_audio():
	var master_bus = AudioServer.get_bus_index("Master")
	var is_muted = AudioServer.is_bus_mute(master_bus)
	AudioServer.set_bus_mute(master_bus, not is_muted)

func _on_modo_associar_pressed():
	$Panel/MarginContainer/PanelContainer/Control/modo_associar.hide()
	$Panel/MarginContainer/PanelContainer/Control/modo_parear.show()
	Globals.game_mode = "Parear"
	Globals.start_game()

func _on_modo_parear_pressed():
	$Panel/MarginContainer/PanelContainer/Control/modo_associar.show()
	$Panel/MarginContainer/PanelContainer/Control/modo_parear.hide()
	Globals.game_mode = "Associar"
	Globals.start_game()
