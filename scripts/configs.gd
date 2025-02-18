extends Node

func _ready():
	$VolumeSlider.value = Globals.master_volume
	$MusicSlider.value = Globals.music_volume
	$SFXSlider.value = Globals.sfx_volume
	$ShuffleCheck.button_pressed = Globals.shuffle_animals
	$HintsCheck.button_pressed = Globals.show_hints

func _on_volume_slider_changed(value):
	Globals.set_master_volume(value)

func _on_music_slider_changed(value):
	Globals.set_music_volume(value)

func _on_sfx_slider_changed(value):
	Globals.set_sfx_volume(value)

func _on_shuffle_toggled(button_pressed):
	Globals.shuffle_animals = button_pressed
	Globals.save_settings()

func _on_hints_toggled(button_pressed):
	Globals.show_hints = button_pressed
	Globals.save_settings()
