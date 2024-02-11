extends Control

const target_scene_path = "res://Scenes/Worlds/Main_Game.tscn"

var loading_status : int
var progress : Array[float]

@onready var progress_bar : ProgressBar = $ProgressBar

func _ready() -> void:
	ResourceLoader.load_threaded_request(target_scene_path)		# Request to load the target scene:
	
func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)	# Update the status:
	
	# Check the loading status:
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))	# When done loading, change to the target scene
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error. Could not load resource")
