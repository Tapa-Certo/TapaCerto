extends CanvasLayer
class_name ScreenController

func toggle_buttons(disable: bool):
	for button in get_tree().get_nodes_in_group("buttons"):
		button.disabled = disable

func appear() -> void:
	#get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "buttons", "set_disabled", false)
	var tween = create_tween()
	tween.tween_property(self, "offset:y", 0, 0.3).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
func disappear() -> void:
	print("b")
	#get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "buttons", "set_disabled", false)
	var tween = create_tween()
	tween.tween_property(self, "offset:y", 900, 0.3).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
