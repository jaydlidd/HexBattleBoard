extends Node

# Preloaded map tiles
var sand_tile = preload("res://Scenes/Map_Tiles/sand_tile.tscn")
var grass_tile = preload("res://Scenes/Map_Tiles/grass_tile.tscn")

# Game settings
var game_settings = {
	"horiz_tiles" = 2,
	"vert_tiles" = 2,
	"map_select" = "pseudorandom",
	"available_tiles" = [sand_tile, grass_tile],
	"player1_pieces" = ["knight", "knight", "knight", "knight"],
	"player2_pieces" = ["knight"]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
