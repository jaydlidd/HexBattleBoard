extends Node

var total_pieces: int = 0

var players_ref = {}								# Reference to player's
var player_scene = preload("res://Scenes/player.tscn")		# Player prefab

# Game settings
var game_settings = {
	"horiz_tiles" = 2,								# Number of map rows
	"vert_tiles" = 2,								# Number of map columns
	"map_select" = "pseudorandom",					# Map Selection
	"available_tiles" = [],							# Available tiles for the map
	"is_loading" = true
}

func populate_player_inventory():
	for id in players_ref:
		print(players_ref)
		print(players_ref[id]["inventory"])
		game_settings[str(id) + "_inventory"] = {}
		game_settings[str(id) + "_inventory_size"] = players_ref[id]["inventory"].size()
		print(game_settings)
		for piece in players_ref[id]["inventory"]:												# For each piece in the player's player1_inventory
			GlobalVars.add_piece(id, piece, str(GlobalVars.total_pieces) + piece)	# Add the piece to their global player1_inventory
			GlobalVars.total_pieces += 1											# Increment the global counter

func spawn_players():
	for i in range(players_ref.size()):
		var current_player = player_scene.instantiate()
		print(current_player)
		print(get_node("/root/MainGame/GridContainer"))
		get_node("/root/MainGame/GridContainer/SubViewportContainer" + str(i) + "/SubViewport").add_child(current_player)
		print(get_node("/root/MainGame/GridContainer/SubViewportContainer" + str(i) + "/SubViewport/PlayerCamera/Camera3D").current)
		print(get_tree().get_nodes_in_group("PlayerSpawnLocation"))
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnLocations"):
			if spawn.name == str(i):
				current_player.global_position = spawn.global_position
				current_player.get_node("Camera3D").make_current()
				print(current_player.global_position)

# Function to get the total piece count for a given player
func get_total_pieces(player_no: int):
	return game_settings[str(player_no) + "_inventory_size"]

# Function to get the current count of pieces in a player's inventory
func get_piece_count(player_no: int):
	return game_settings[str(player_no) + "_inventory"].size()

# Add a piece to a player's inventory
func add_piece(player_no: int, piece: String, piece_name: String):
	game_settings[str(player_no) + "_inventory"][piece_name] = {
		"piece_type": piece,
		"piece_name": piece_name
	}

# Take a piece from a given player's inventory and return it
func take_piece(player_no: int, piece_name: String):
	var taken_piece = game_settings[str(player_no) + "_inventory"][piece_name]
	game_settings[str(player_no) + "_inventory"].erase(piece_name)
	return taken_piece

# Function to find a node in the current scene with a given object ID
func find_node_by_id(collided_object_id):
	if collided_object_id == null:		# Return null if provided a null ID
		return null
		
	var scene_children:Array = get_node("/root/MainGame").get_children()			# Get the children nodes of the current scene's root
	var scene_child_count:int = get_node("/root/MainGame").get_child_count()		# Get the current scene's root count of children

	# For each of the root node's children
	for i in range(scene_child_count):
		var current_children_of_node = scene_children[i].get_children()			# Get the current node's children
		var current_child_count_of_node = scene_children[i].get_child_count()	# Get the current node's count of children

		# For each of the current children of the child of the root node
		for j in range(current_child_count_of_node):
			if current_children_of_node[j].get_instance_id() == collided_object_id:		# If the instance ID of this node matches the collider ID
				return current_children_of_node[j]
