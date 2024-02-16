extends CanvasLayer

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scene/world.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scene/selectionmenu.tscn")
