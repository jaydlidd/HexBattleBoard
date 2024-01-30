extends Node3D

var sand_tile = preload("res://Scenes/Map_Tiles/sand_map_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_map()

func load_map():
	# Array of preloaded tile scenes
	var possible_tiles = [sand_tile]
	
	# Map created with possible tiles randomised in a preset amount
	var map = design_random_preset_map(2,2,possible_tiles)
	
	# Add the tiles to the world scene
	for i in map.size():
		add_child(map[i])

func design_random_preset_map(x:int, y:int, possible_tiles:Array):
	# Called with a size x and y which is the number of tiles tall and wide the map will be
	var map_tile_list = []
	var offset
	var row_height = 3.6
	var col_width = 4.8
	
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
