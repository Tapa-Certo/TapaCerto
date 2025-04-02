extends Node

signal game_started
signal game_reset
signal game_paused
signal game_resumed
signal level_completed


const SAVE_PATH = "user://settings.save"

var master_volume: 	float = 1.0
var music_volume: 	float = 1.0
var sfx_volume: 	float = 1.0

var shuffle_grid: 	bool = false
var show_hints: 	bool = true
var enable_sound: 	bool = true


var difficulty_level: 	String = "facil" #facil, normal, dificil
var game_mode: 			String = "Associar" #"Parear" ou "Associar"

const HIGHLIGHT_COLOR:	Color	= Color(1, 1, 1)  # Verde claro
const SHAKE_INTENSITY: 	float 	= 8.0
const SHAKE_DURATION: 	float 	= 0.4

var items_oppacity: Color = Color(1, 1, 1, 0.3) #0.0 item some #0.3 item transparente #1 item aparente normalmente #DEIXAR UMA MAX DE ATE 0.5
var item_size: Vector2 = Vector2(100,100) #LEMBRAR QUE ABAIXO DE 75 ELE DESCENTRALIZA E ACIMA DE 100 TABMEM

var max_rows: 	 int = 4
var max_columns: int = 4
var current_rows: 	 int  = 3
var current_columns: int  = 4

var is_paused: 	bool = false
var in_game: 	bool = false

var item_to_animal: Dictionary = {
	"banana": "macaco",
	"maca": "cavalo",
	"amendoim": "elefante",
	"arvore": "girafa",
	"aquario": "peixe",
	"carne": "leao",
	"cenoura": "coelho",
	"flor": "abelha",
	"gelo": "pinguim",
	"lama": "porco",
	"leite": "vaca",
	"mel": "urso",
	"milho": "galinha",
	"novelo": "gato",
	"osso": "cachorro",
	"noz": "esquilo"
}

var item_to_item: Dictionary = {
	"macaco": "macaco",
	"cavalo": "cavalo",
	"elefante": "elefante",
	"girafa": "girafa",
	"peixe": "peixe",
	"leao": "leao",
	"coelho": "coelho",
	"abelha": "abelha",
	"pinguim": "pinguim",
	"porco": "porco",
	"vaca": "vaca",
	"urso": "urso",
	"galinha": "galinha",
	"gato": "gato",
	"cachorro": "cachorro",
	"esquilo": "esquilo",
	"banana": "banana",
	"maca": "maca",
	"amendoim": "amendoim",
	"arvore": "arvore",
	"aquario": "aquario",
	"carne": "carne",
	"cenoura": "cenoura",
	"flor": "flor",
	"gelo": "gelo",
	"lama": "lama",
	"leite": "leite",
	"mel": "mel",
	"milho": "milho",
	"novelo": "novelo",
	"osso": "osso",
	"noz": "noz"
}

var itens_array: Array = [
	"macaco", 
	"cavalo", 
	"elefante", 
	"girafa", 
	"peixe",
	"leao", 
	"coelho", 
	"abelha", 
	"pinguim", 
	"porco", 
	"vaca", 
	"urso", 
	"galinha", 
	"gato", 
	"cachorro", 
	"esquilo",
	"banana", 
	"maca", 
	"amendoim", 
	"arvore", 
	"aquario",
	"carne", 
	"cenoura", 
	"flor", 
	"gelo", 
	"lama",
	"leite", 
	"mel", 
	"milho", 
	"novelo", 
	"osso", 
	"noz",
	"passaro",
	"minhoca"
	]

#Criar logica para que ao mudar a dificuldade as outras configuracoes mudem automaticamente
func _ready() -> void:
	load_settings()
	
func save_settings() -> void:
	var settings = {
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"shuffle_grid": shuffle_grid,
		"show_hints": show_hints,
		"difficulty_level": difficulty_level
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(settings)
	file.store_string(json_string)

func load_settings() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	var settings = JSON.parse_string(json_string)
	
	if settings:
		master_volume = settings.get("master_volume", 1.0)
		music_volume = settings.get("music_volume", 1.0)
		sfx_volume = settings.get("sfx_volume", 1.0)
		shuffle_grid = settings.get("shuffle_grid", true)
		show_hints = settings.get("show_hints", true)
		difficulty_level = settings.get("difficulty_level", "facil")
		
func set_master_volume(value: float) -> void:
	master_volume = value
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value)
	)
	save_settings()

func set_music_volume(value: float) -> void:
	music_volume = value
	#FAZER LOGICA PARA ATUALIZAR VOLUME
	save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	#FAZER LOGICA PARA ATUALIZAR VOLUME
	save_settings()


func set_difficulty(new_difficulty: String) -> void:
	difficulty_level = new_difficulty
	
	match difficulty_level:
		"facil":
			current_rows = 3
			current_columns = 4
			show_hints = true
		"normal":
			current_rows = 4
			current_columns = 5
			show_hints = true
		"dificil":
			current_rows = 5
			current_columns = 6
			show_hints = false
	
	save_settings()
	emit_signal("difficulty_changed", new_difficulty)

func set_game_mode(new_mode: String) -> void:
	save_settings()
	emit_signal("game_mode_changed", new_mode)

func start_game() -> void:
	in_game = true
	print("game_started")
	emit_signal("game_started")
	
func reset_game() -> void:
	in_game = false
	print("game_reset")
	emit_signal("game_reset")

func pause_game() -> void:
	is_paused = true
	print("game_paused")
	emit_signal("game_paused")

func resume_game() -> void:
	is_paused = false
	print("game_resumed")
	emit_signal("game_resumed")

func complete_level() -> void:
	print("level_completed")
	emit_signal("level_completed")

