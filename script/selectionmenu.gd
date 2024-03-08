extends Node2D

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scene/world.tscn")

func _on_start_3_pressed():
	get_tree().change_scene_to_file("res://scene/city.tscn")

func _on_start_2_pressed():
	get_tree().change_scene_to_file("res://scene/night_quarter.tscn")


#multiplayer selection
func _on_start_5_pressed():
	get_tree().change_scene_to_file("res://scene/multiplayer_world.tscn")


func _on_start_4_pressed():
	get_tree().change_scene_to_file("res://scene/multi_map_2.tscn")

func _on_start_6_pressed():
	get_tree().change_scene_to_file("res://scene/multi_map_3.tscn")
