extends Node
var log_data: Array = []
var session_start_time: int
static var _instance: Logger = null
var start_time: int = 0
var definitive_time: int = 0
var number_of_corrects: int = 0
var number_of_incorrects: int = 0
var total_response_time_correct: int = 0
var total_response_time_incorrect: int = 0

static func get_instance() -> Node:
	if not _instance:
		_instance = load("res://scripts/data_collector/logger.gd").new()
		_instance._init()
	return _instance

func _init():
	session_start_time = Time.get_unix_time_from_system()

func create_log_entry(event_type: String, time_action: int, details: Dictionary = {}) -> Dictionary:
	print("Log criado")
	var entry = {
		"time_elapsed": time_action,
		"event_type": event_type,
	}
	entry.merge(details)
	log_data.append(entry)
	return entry

func log_button_click(animal_selected: String, current_fruit: String):
	start_timer()
	create_log_entry("button_click", 0, {
		"animal_selected": animal_selected,
		"current_fruit": current_fruit
	})

func log_correct_answer(animal_selected: String):
	number_of_corrects += 1
	print("Resposta correta, total ate agora: ", number_of_corrects)
	var elapsed_time = stop_timer()
	total_response_time_correct += elapsed_time
	create_log_entry("correct_answer", elapsed_time, {
		"animal_selected": animal_selected,
	})

func log_incorrect_answer(): 
	number_of_incorrects += 1
	print("Resposta ERRADA, total ate agora: ", number_of_incorrects)
	var elapsed_time = stop_timer()
	total_response_time_incorrect += elapsed_time
	create_log_entry("incorrect_answer", elapsed_time, {})

func start_timer():
	start_time = Time.get_ticks_msec()

func stop_timer():
	var elapsed_time = Time.get_ticks_msec() - start_time
	return elapsed_time

func calculate_metrics():
	definitive_time = Time.get_unix_time_from_system() - session_start_time
	var avg_time_correct : float = 0 if number_of_corrects == 0 else total_response_time_correct / number_of_corrects
	var avg_time_incorrect : float = 0 if number_of_incorrects == 0 else total_response_time_incorrect / number_of_incorrects
	var total_responses : float = number_of_corrects + number_of_incorrects
	var avg_correct_percentage : float = 0 if total_responses == 0 else (number_of_corrects/ total_responses) * 100
	var avg_incorrect_percentage : float = 100.0 - avg_correct_percentage
	return {
		"Tempo Total de Jogo (s)": definitive_time,
		"Tempo Medio por Resposta Correta (ms)": avg_time_correct,
		"Tempo Medio por Resposta Errada (ms)": avg_time_incorrect,
		"Quantidade de Respostas Certas": number_of_corrects,
		"Media de Respostas Certas (%)": avg_correct_percentage,
		"Quantidade de Respostas Erradas": number_of_incorrects,
		"Media de Respostas Erradas (%)": avg_incorrect_percentage
	}

func save_logs():
	var metrics = calculate_metrics()
	var downloads_path = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
	var file_path = downloads_path + "/game_logs.csv"
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		print("Log salvo em: ", file_path)
	else:
		print("Erro ao salvar log.")
		return
	
	# Cabeçalhos
	var headers = [
	"Tempo Total de Jogo (s)",
	"Tempo Medio por Resposta Correta (ms)",
	"Tempo Medio por Resposta Errada (ms)",
	"Quantidade de Respostas Certas",
	"Media de Respostas Certas (%)",
	"Quantidade de Respostas Erradas",
	"Media de Respostas Erradas (%)"
]
	file.store_string(";".join(headers) + "\n")
	
	# Valores
	var values = []
	values.append(str(metrics["Tempo Total de Jogo (s)"]))
	values.append("%.2f" % metrics["Tempo Medio por Resposta Correta (ms)"])
	values.append("%.2f" % metrics["Tempo Medio por Resposta Errada (ms)"])
	values.append(str(metrics["Quantidade de Respostas Certas"]))
	values.append("%.2f" % metrics["Media de Respostas Certas (%)"])
	values.append(str(metrics["Quantidade de Respostas Erradas"]))
	values.append("%.2f" % metrics["Media de Respostas Erradas (%)"])

	file.store_string(";".join(values) + "\n")
	file.close()
	#print("Logs salvos em: ", file_path)
