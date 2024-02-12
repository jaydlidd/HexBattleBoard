extends Node3D

# Map variables
var row_height = 3.6
var col_width = 4.8
var map_tile_list = []
var map:Array
var tile_count:int = 0
var max_tiles = 100

# Player variables
var current_player_no: int = 1

# Preloaded map tiles
var sand_tile = preload("res://Scenes/Map_Tiles/sand_tile.tscn")
var grass_tile = preload("res://Scenes/Map_Tiles/grass_tile.tscn")

# Loading screen
#var loading_screen = preload("res://Scenes/UI/loading_cover.tscn")

var player_inventory = ["knight", "farmer", "farmer"]

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass
	
# Called every frame
func _process(_delta):
	pass
#	print(get_node("root/MainGame/"))
#	if get_node("Control/LoadingCover") != null:
#		if GlobalVars.game_settings["is_loading"] == false:		# If not loading...
#			get_node("Control/LoadingCover").visible = false	# Hide loading screen
#		else:													# If loading...
#			get_node("Control/LoadingCover").visible = true		# Show loading screen

func setup_game():
	var available_tiles = [sand_tile, grass_tile]					# List of available tiles to build a map
	GlobalVars.game_settings["available_tiles"] = available_tiles
	load_map(GlobalVars.game_settings["map_select"])	# Load the map based on selection
	
#	GlobalVars.populate_player_inventory()
	GlobalVars.spawn_players()

# Function to load the selected map using the possible tiles.
# 	It also spawns the tiles into the scene.
func load_map(map_select:String):
	var possible_tiles = GlobalVars.game_settings["available_tiles"] # Array of preloaded tile scenes
	match map_select:									# Match based on the selected map
		"pseudorandom":									# Map created with possible tiles randomised in a preset amount
			map = design_random_preset_map(
			GlobalVars.game_settings["horiz_tiles"], 
			GlobalVars.game_settings["vert_tiles"], 
			possible_tiles)
		"random":										# Map created with a random size and random tiles
			map = design_random_map(possible_tiles)

	for i in map.size():	# Add the tiles to the world scene
		add_child(map[i])

# Design a map of tiles of a preset size with the available tiles
func design_random_preset_map(x:int, y:int, possible_tiles:Array):
	var offset		# Variable to store the offset to align vertical hexagons
	
	for i in range(x):
		# Determine if need to offset, odd rows offset by 50%
		if i % 2 == 0:
			offset = 0
		else:
			offset = 2.4
		
		var rand_tile = possible_tiles[randi()% possible_tiles.size()]	# Pick random tile type
		var tile = rand_tile.instantiate()								# Create the tile
		tile.name = str(tile_count) + "_" + tile.name					# Name the tile so we can reference it
		tile.position = Vector3((i * row_height), 0, 0 + offset)		# Set the tile position
		map_tile_list.append(tile)										# Add the tile to the map list
		tile_count += 1													# Increment the counter
		
		for j in range(y - 1):
			rand_tile = possible_tiles[randi()% possible_tiles.size()]						# Pick random tile type
			tile = rand_tile.instantiate()													# Create the tile
			tile.name = str(tile_count) + "_" + tile.name									# Name the tile so we can reference it
			tile.position = Vector3((i * row_height), 0, ((j + 1) * col_width) + offset)	# Set the tile position
			map_tile_list.append(tile)														# Add the tile to the map list
			tile_count += 1																	# Increment the counter
	
	return map_tile_list

# Function to generate up to 100 map tiles randomly. Random tile placement
# 	as well as a random number of total tiles.
func design_random_map(possible_tiles:Array):	
	var total_tiles = randi()% max_tiles					# Find a random positive integer between 0 and max_tiles
	var divisors:Array = get_divisors(total_tiles)			# Find two divisors that make up the total_tiles number
	
	print("Divisors array: ", divisors)	# DEBUG
	print("Total tiles: ", total_tiles)	# DEBUG

	var horiz_tiles = divisors[randi()% divisors.size()]	# Pick a random divisor
	var vert_tiles = total_tiles / horiz_tiles				# Find the pair divisor by dividing total_tiles by the divisor
	
	return design_random_preset_map(horiz_tiles, vert_tiles, possible_tiles)	# Generate the design for total_tiles map

# Get all divisors of a given integer
func get_divisors(num:int):
	var divisors = []			# Function to return all known divisors of a given integer
	
	for i in range(2, num):		# For each integer in the range of 2 (inclusive) to the integer
		if num % i == 0:		# If num modulo i is 0
			divisors.append(i)	# Add the divisor
			
	return divisors

# Called when the node enters the scene tree for the first time.
#func _ready():
	


