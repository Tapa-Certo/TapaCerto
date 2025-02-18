extends Node

const SAVE_PATH = "user://settings.save"

var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

var shuffle_animals: bool = true
var show_hints: bool = true

var difficulty_level: String = "normal" #facil, normal, dificil
#Criar logica para que ao mudar a dificuldade as outras configuracoes mudem automaticamente
func _ready():
	load_settings()
	
func save_settings():
	var settings = {
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"shuffle_animals": shuffle_animals,
		"show_hints": show_hints,
		"difficulty_level": difficulty_level
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(settings)
	file.store_string(json_string)

func load_settings():
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	var settings = JSON.parse_string(json_string)
	
	if settings:
		master_volume = settings.get("master_volume", 1.0)
		music_volume = settings.get("music_volume", 1.0)
		sfx_volume = settings.get("sfx_volume", 1.0)
		shuffle_animals = settings.get("shuffle_animals", true)
		show_hints = settings.get("show_hints", true)
		difficulty_level = settings.get("difficulty_level", "normal")
		
func set_master_volume(value: float):
	master_volume = value
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value)
	)
	save_settings()

func set_music_volume(value: float):
	music_volume = value
	#FAZER LOGICA PARA ATUALIZAR VOLUME
	save_settings()

func set_sfx_volume(value: float):
	sfx_volume = value
	#FAZER LOGICA PARA ATUALIZAR VOLUME
	save_settings()
