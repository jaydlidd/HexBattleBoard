extends HBoxContainer

var game_player_no = 1
var piece_button:Node

# Pieces preloaded
var knight_piece:PackedScene = preload("res://Scenes/UI/Knight_Piece_Button.tscn")
var farmer_piece:PackedScene = preload("res://Scenes/UI/Farmer_Piece_Button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get this player's pieces
	var pieces:Array = GlobalVars.game_settings[str("player", game_player_no,"_pieces")]
	
	# Create the buttons for each piece
	for i in range(pieces.size()):
		match pieces[i]:
			"knight":
				piece_button = knight_piece.instantiate()
			"farmer":
				piece_button = farmer_piece.instantiate()
		
		# Place the button equally into the container
		# Size of button is 100 units, and they're seperated by 8 units
		# e.g. 8 (units from edge of container) + i (number of buttons) * 100 (size of button) + 8
		piece_button.position = Vector2(8+(i*(100+8)),0)
		add_child(piece_button)
