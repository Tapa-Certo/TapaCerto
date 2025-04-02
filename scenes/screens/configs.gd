extends CanvasLayer

func _on_audio_on_pressed():
	$Panel/MarginContainer/PanelContainer/Control/audio_on.hide()
	$Panel/MarginContainer/PanelContainer/Control/audio_off.show()
	toggle_audio()

func _on_audio_off_pressed():
	$Panel/MarginContainer/PanelContainer/Control/audio_off.hide()
	$Panel/MarginContainer/PanelContainer/Control/audio_on.show()

func toggle_audio():
	var master_bus = AudioServer.get_bus_index("Master") 
	var is_muted = AudioServer.is_bus_mute(master_bus)
	AudioServer.set_bus_mute(master_bus, not is_muted)
