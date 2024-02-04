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
	"player1_pieces" = ["knight", "knight", "knight", "farmer"],
	"player2_pieces" = ["knight"]
}
