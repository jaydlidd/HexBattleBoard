extends Node

var total_pieces: int = 0

# Game settings
var game_settings = {
	"horiz_tiles" = 2,								# Number of map rows
	"vert_tiles" = 2,								# Number of map columns
	"map_select" = "pseudorandom",					# Map Selection
	"available_tiles" = [],							# Available tiles for the map
	"is_loading" = true,
	"player1_inventory" = {},						# Inventory of Player 1
	"player2_pieces" = {},							# Inventory of Player 2
	"p1_total_pieces" = 0,							# Count of total pieces at the start of the game for Player 1
	"p2_total_pieces" = 0							# Count of total pieces at the start of the game for Player 2
}

# Function to get the total piece count for a given player
func get_total_pieces(player_no: int):
	if player_no == 1:
		return game_settings["p1_total_pieces"]
	if player_no == 2:
		return game_settings["p2_total_pieces"]

# Function to set the total piece count for a given player
func set_total_pieces(player_no: int, no_pieces: int):
	if player_no == 1:
		game_settings["p1_total_pieces"] = no_pieces
	if player_no == 2:
		game_settings["p2_total_pieces"] = no_pieces

# Function to get the current count of pieces in a player's inventory
func get_piece_count(player_no: int):
	if player_no == 1:
		return game_settings["player1_inventory"].size()
	if player_no == 2:
		return game_settings["player2_pieces"].size()

# Add a piece to a player's inventory
func add_piece(player_no: int, piece: String, piece_name: String):
	game_settings["player" + str(player_no) + "_inventory"][piece_name] = {"piece_type": piece}

# Take a piece from a given player's inventory and return it
func take_piece(player_no: int, piece_name: String):
	var taken_piece = game_settings["player" + str(player_no) + "_inventory"][piece_name]
	game_settings["player" + str(player_no) + "_inventory"].erase(piece_name)
	return taken_piece

# Function to find a node in the current scene with a given object ID
func find_node_by_id(collided_object_id):
	if collided_object_id == null:		# Return null if provided a null ID
		return null
		
	var scene_children:Array = get_tree().current_scene.get_children()			# Get the children nodes of the current scene's root
	var scene_child_count:int = get_tree().current_scene.get_child_count()		# Get the current scene's root count of children
	
	# For each of the root node's children
	for i in range(scene_child_count):
		var current_children_of_node = scene_children[i].get_children()			# Get the current node's children
		var current_child_count_of_node = scene_children[i].get_child_count()	# Get the current node's count of children

		# For each of the current children of the child of the root node
		for j in range(current_child_count_of_node):
			if current_children_of_node[j].get_instance_id() == collided_object_id:		# If the instance ID of this node matches the collider ID
				return current_children_of_node[j]
