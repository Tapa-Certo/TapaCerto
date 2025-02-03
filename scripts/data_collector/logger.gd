extends Node

var _log_data: Array = []
var _session_start_time: int

#EXPLICACAO POR ZOREIUDO DO ALEMAO
#CRIA UMA VARIAVEL ESTATICA DO LOGGER
static var _instance: Logger = null

#ISSO AQUI É CHAMADO NA INSTANCIACAO DO GAME_MANAGER DO JOGO E INSTANCIA O LOGGER UMA UNICA VEZ
static func get_instance() -> Node:
	if not _instance:
		_instance = load("res://scripts/data_collector/logger.gd").new()
		
	return _instance

#PEGA O TEMPO QUE INICIOU, PENSEI NISSO PRA CASO A GENTE QUEIRA SABER O TEMPO ENTRE UMA ACAO E OUTRA
func _init():
	_session_start_time = Time.get_unix_time_from_system()

#ISSO AQUI É A BASE DO LOGGER, A ENTRADA DELE É O TIPO E OS DETALHES(BOTAO, ACERTOU OU ERROU, CLICOU NA TELA, ...)
func _create_log_entry(event_type: String, details: Dictionary = {}) -> Dictionary:
	var timestamp = Time.get_unix_time_from_system()
	var entry = {
		"timestamp": timestamp,
		"time_since_start": timestamp - _session_start_time,
		"event_type": event_type,
	}
	entry.merge(details)
	_log_data.append(entry)
	return entry

#=================================================================================================================#
#SEGUIR ESSA ESTRUTURA PARA CADA LOG QUE FOR CRIADO
func log_button_click(animal_selected: String, current_fruit: String):
	_create_log_entry("button_click", {
		"animal_selected": animal_selected,
		"current_fruit": current_fruit
	})

func log_correct_answer(animal_selected: String, time_taken: float):
	_create_log_entry("correct_answer", {
		"animal_selected": animal_selected,
		"time_taken": time_taken
	})
	
#=================================================================================================================#
func save_logs():
	var file: FileAccess = FileAccess.open("user://game_logs.json", FileAccess.WRITE)
	var json_string: String = JSON.stringify(_log_data, "\t")
	file.store_string(json_string)
	file.close()
