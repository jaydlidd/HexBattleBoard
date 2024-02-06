extends Node

# Preloaded map tiles
var sand_tile = preload("res://Scenes/Map_Tiles/sand_tile.tscn")
var grass_tile = preload("res://Scenes/Map_Tiles/grass_tile.tscn")

var total_pieces: int = 0

# Game settings
var game_settings = {
	"horiz_tiles" = 2,
	"vert_tiles" = 2,
	"map_select" = "pseudorandom",
	"available_tiles" = [sand_tile, grass_tile],
	"player1_pieces" = {},
	"player2_pieces" = ["knight"],
	"p1_total_pieces" = 0,
	"p2_total_pieces" = 0
}

func get_total_pieces(player_no: int):
	if player_no == 1:
		return game_settings["p1_total_pieces"]
	if player_no == 2:
		return game_settings["p2_total_pieces"]

func set_total_pieces(player_no: int, no_pieces: int):
	if player_no == 1:
		game_settings["p1_total_pieces"] = no_pieces
	if player_no == 2:
		game_settings["p2_total_pieces"] = no_pieces

func get_piece_count(player_no: int):
	if player_no == 1:
		return game_settings["player1_pieces"].size()
	if player_no == 2:
		return game_settings["player2_pieces"].size()

func add_piece(player_no: int, piece: String, piece_name: String):
	game_settings["player" + str(player_no) + "_pieces"][get_piece_count(player_no)] = {"piece": piece, "piece_name": piece_name}

func find_node_by_id(collided_object_id: int):
	var scene_children:Array = get_tree().current_scene.get_children()
	var scene_child_count:int = get_tree().current_scene.get_child_count()
	
	# For each of the root node's children
	for i in range(scene_child_count):
		var current_children_of_node = scene_children[i].get_children()			# Get the current node's children
		var current_child_count_of_node = scene_children[i].get_child_count()	# Get the current node's count of children

		# For each of the current children of the child of the root node
		for j in range(current_child_count_of_node):
			# If the instance ID of this node matches the collider ID
			if current_children_of_node[j].get_instance_id() == collided_object_id:
				return current_children_of_node[j]
