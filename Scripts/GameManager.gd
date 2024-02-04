extends Node3D

# Map variables
var row_height = 3.6
var col_width = 4.8
var map_tile_list = []
var map:Array

# Called when the node enters the scene tree for the first time.
func _ready():	
	# Load the map
	load_map(GlobalVars.game_settings["map_select"])

func load_map(map_select:String):
	# Array of preloaded tile scenes
	var possible_tiles = GlobalVars.game_settings["available_tiles"]
		
	match map_select:
		# Map created with possible tiles randomised in a preset amount
		"pseudorandom":
			map = design_random_preset_map(
			GlobalVars.game_settings["horiz_tiles"], 
			GlobalVars.game_settings["vert_tiles"], 
			possible_tiles)
		# Map created with a random size and random tiles
		"random":
			map = design_random_map(possible_tiles)
	
	# Add the tiles to the world scene
	for i in map.size():
		add_child(map[i])

func design_random_preset_map(x:int, y:int, possible_tiles:Array):
	# Called with a size x and y which is the number of tiles tall and wide the map will be
	var offset
	
	for i in range(x):
		# Determine if need to offset, odd rows offset by 50%
		if i % 2 == 0:
			offset = 0
		else:
			offset = 2.4
		
		# Pick random tile type
		var rand_tile = possible_tiles[randi()% possible_tiles.size()]
		
		# Create the tile
		var tile = rand_tile.instantiate()
		
		# Set the tile position
		tile.position = Vector3((i * row_height), 0, 0 + offset)
		
		# Add the tile to the map list
		map_tile_list.append(tile)
		
		for j in range(y - 1):
			# Pick random tile type
			rand_tile = possible_tiles[randi()% possible_tiles.size()]
			
			# Create the tile
			tile = rand_tile.instantiate()
			
			# Set the tile position
			tile.position = Vector3((i * row_height), 0, ((j + 1) * col_width) + offset)
			
			# Add the tile to the map list
			map_tile_list.append(tile)
		
	return map_tile_list

func design_random_map(possible_tiles:Array):
	# Function to generate up to 100 map tiles randomly. Random tile placement
	# 	as well as a random number of total tiles.
	var max_tiles = 100
	
	# Find a random positive integer between 0 and max_tiles
	var total_tiles = randi()% max_tiles
	
	# Now we know the total tiles, we need to find two divisors that make up the total_tiles number.
	var divisors:Array = get_divisors(total_tiles)
	
	print("Divisors array: ", divisors)	# DEBUG
	print("Total tiles: ", total_tiles)	# DEBUG
	
	# Pick a random divisor, and to find it's pair we divide total_tiles by the divisor
	var horiz_tiles = divisors[randi()% divisors.size()]
	var vert_tiles = total_tiles / horiz_tiles
	
	# Generate the design for total_tiles map
	return design_random_preset_map(horiz_tiles, vert_tiles, possible_tiles)

func get_divisors(num:int):
	# Function to return all known divisors of a given integer
	var divisors = []
	
	# For each integer in the range of 2 (inclusive) to the integer
	for i in range(2, num):
		if num % i == 0:
			divisors.append(i)
			
	return divisors
