extends Control

const loading_scene_path = "res://Scenes/Worlds/Loading_Screen.tscn"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(loading_scene_path)
