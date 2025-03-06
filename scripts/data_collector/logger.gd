extends Node

var _log_data: Array = []
var _session_start_time: int

#EXPLICACAO POR ZOREIUDO DO ALEMAO
#CRIA UMA VARIAVEL ESTATICA DO LOGGER
static var _instance: Logger = null

var start_time: int = 0
var definitiveTime: int = 0
var numberOfCorrects: int = 0
var incorrect_answer: int = 0 


#ISSO AQUI É CHAMADO NA INSTANCIACAO DO GAME_MANAGER DO JOGO E INSTANCIA O LOGGER UMA UNICA VEZ
static func get_instance() -> Node:
	if not _instance:
		_instance = load("res://scripts/data_collector/logger.gd").new()
		_instance._init()
	return _instance

#PEGA O TEMPO QUE INICIOU, PENSEI NISSO PRA CASO A GENTE QUEIRA SABER O TEMPO ENTRE UMA ACAO E OUTRA
func _init():
	_session_start_time = Time.get_unix_time_from_system()

#ISSO AQUI É A BASE DO LOGGER, A ENTRADA DELE É O TIPO E OS DETALHES(BOTAO, ACERTOU OU ERROU, CLICOU NA TELA, ...)
func _create_log_entry(event_type: String, time_action: int, details: Dictionary = {}) -> Dictionary:
	#var timestamp = Time.get_unix_time_from_system()
	var time_for_correct
	var entry = {
		#"timestamp": timestamp,
		#"time_since_start": timestamp - _session_start_time, #CALCULO DO TEMPO ESTA ERRADO
		"time_for_correct": time_for_correct,
		"event_type": event_type,
	}
	entry.merge(details)
	_log_data.append(entry)
	return entry

#=================================================================================================================#
#SEGUIR ESSA ESTRUTURA PARA CADA LOG QUE FOR CRIADO
func log_button_click(animal_selected: String, current_fruit: String):
	_create_log_entry("button_click", start_timer(), {
		"animal_selected": animal_selected,
		"current_fruit": current_fruit
	})

func log_correct_answer(animal_selected: String):
	incorrect_answer = 0
	_create_log_entry("correct_answer", stop_timer(), {
		"animal_selected": animal_selected,
	})
	
func log_incorrect_answer(): 
	incorrect_answer = incorrect_answer + 1

# FUNÇÕES PARA DEFINIR O TEMPO ENTRE CADA AÇÃO 
# Começa o contador 
func start_timer():
	start_time = Time.get_ticks_msec()

# Termina o contador e printa o tempo gasto por ação 
func stop_timer():
	var elapsed_time = Time.get_ticks_msec() - start_time
	print("Tempo decorrido: ", elapsed_time, " ms")
	return elapsed_time
	
#=================================================================================================================#
func save_logs():
	#TO-DO
	#1. SALVAR DOCUMENTO POR SESSAO
	#2. SALVAR EM .XLS
	var file: FileAccess = FileAccess.open("user://game_logs.json", FileAccess.WRITE)
	var json_string: String = JSON.stringify(_log_data, "\t")
	file.store_string(json_string)
	file.close()
