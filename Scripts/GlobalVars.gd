extends Node

# Preloaded map tiles
var sand_tile = preload("res://Scenes/Map_Tiles/sand_tile.tscn")
var grass_tile = preload("res://Scenes/Map_Tiles/grass_tile.tscn")

# Piece variables
var p1_piece_count: int = 0
var p2_piece_count: int = 0
var p1_total_piece: int = 0
var p2_total_piece: int = 0

# Game settings
var game_settings = {
	"horiz_tiles" = 2,
	"vert_tiles" = 2,
	"map_select" = "pseudorandom",
	"available_tiles" = [sand_tile, grass_tile],
	"player1_pieces" = ["knight", "knight", "knight", "farmer"],
	"player2_pieces" = ["knight"]
}

func get_total_pieces(player_no: int):
	if player_no == 1:
		return p1_total_piece
	if player_no == 2:
		return p2_total_piece

func set_total_pieces(player_no: int, no_pieces: int):
	if player_no == 1:
		p1_total_piece = no_pieces
	if player_no == 2:
		p2_total_piece = no_pieces

func get_piece_count(player_no: int):
	if player_no == 1:
		return p1_piece_count
	if player_no == 2:
		return p2_piece_count
	
func set_piece_count(player_no: int, no_pieces: int):
	if player_no == 1:
		p1_piece_count = no_pieces
	if player_no == 2:
		p2_piece_count = no_pieces
	
func decrease_piece_count(player_no: int, no_pieces: int):
	if player_no == 1:
		p1_piece_count -= no_pieces
	if player_no == 2:
		p2_piece_count -= no_pieces

func increase_piece_count(player_no: int, no_pieces: int):
	if player_no == 1:
		p1_piece_count += no_pieces
	if player_no == 2:
		p2_piece_count += no_pieces
