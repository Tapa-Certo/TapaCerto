extends Node

const SAVE_PATH = "user://settings.save"

var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

var shuffle_grid: bool = false
var show_hints: bool = true
var enable_sound: bool = false

#facil, normal, dificil
var difficulty_level: String = "normal" 
#"Parear" ou "Associar"
var game_mode: String = "Parear" 

const HIGHLIGHT_COLOR = Color(1, 1, 1)  # Verde claro
const SHAKE_INTENSITY = 8.0
const SHAKE_DURATION = 0.4


var items_oppacity: Color = Color(1, 1, 1, 0.3) #0.0 item some #0.3 item transparente #1 item aparente normalmente #DEIXAR UMA MAX DE ATE 0.5
var item_size: Vector2 = Vector2(100,100) #LEMBRAR QUE ABAIXO DE 75 ELE DESCENTRALIZA E ACIMA DE 100 TABMEM

var max_rows = 4
var max_columns = 4

var current_rows = 3
var current_columns = 4

# Variaveis do hint_manager
var time_since_last_selection: float = 0.0
var incorrect_attempts: int = 0
var current_fruit: String = ""
var hint_triggered: bool = false

# Variaveis do grid_manager
var viewport_size = get_viewport().size
var available_width = viewport_size.x * 0.6 # 80% da largura da viewport
var available_height = viewport_size.y * 0.6  # 80% da altura da viewport


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
func _ready():
	load_settings()
	
func save_settings():
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
		shuffle_grid = settings.get("shuffle_grid", true)
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


"""
var animal_to_fruit: Dictionary = {
	"macaco": "banana",
	"cavalo": "maca",
	"elefante": "amendoim",
	"girafa": "arvore",
	"peixe": "aquario",
	"leao": "carne",
	"coelho": "cenoura",
	"abelha": "flor",
	"pinguim": "gelo",
	"porco": "lama",
	"vaca": "leite",
	"urso": "mel",
	"galinha": "milho",
	"gato": "novelo",
	"cachorro": "osso",
	"esquilo": "noz"
}

var fruit_to_fruit: Dictionary = {
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

var animal_to_animal: Dictionary = {
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
	"esquilo": "esquilo"
}"""
