extends Node3D

# DEV = Set the number of horizontal and vertical tiles of the preset_map
@export var horiz_tiles = 2
@export var vert_tiles = 2

# Preloaded map tiles
#var sand_tile = preload("res://Scenes/Map_Tiles/sand_map_tile.tscn")
#var grass_tile = preload("res://Scenes/Map_Tiles/grass_map_tile.tscn")

# Map variables
var row_height = 3.6
var col_width = 4.8
var map_tile_list = []

var global_mouse_pos = Vector2.ZERO

# Called to return the current mouse position
func get_global_mouse_pos():
	return global_mouse_pos
	
func get_global_mouse_pos_x():
	return global_mouse_pos.x
	
func get_global_mouse_pos_y():
	return global_mouse_pos.y

func set_global_mouse_pos(new_pos: Vector2):
	global_mouse_pos = new_pos

# Called when the node enters the scene tree for the first time.
func _ready():
#	load_map()
	pass

#func load_map():
	# Array of preloaded tile scenes
#	var possible_tiles = [sand_tile, grass_tile]
	
	# Map created with possible tiles randomised in a preset amount
#	var map = design_random_preset_map(horiz_tiles, vert_tiles, possible_tiles)
#	var map = design_random_map(possible_tiles)
	
	# Add the tiles to the world scene
#	for i in map.size():
#		add_child(map[i])

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
	horiz_tiles = divisors[randi()% divisors.size()]
	vert_tiles = total_tiles / horiz_tiles
	
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
