extends HBoxContainer

var game_player_no = 1
var piece_button:Node

# Pieces preloaded
var knight_piece:PackedScene = preload("res://Scenes/UI/Knight_Piece_Button.tscn")
var farmer_piece:PackedScene = preload("res://Scenes/UI/Farmer_Piece_Button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout		# Wait to begin building the inventory for the pieces to be added
	# Get this player's pieces
	var pieces:Dictionary = GlobalVars.game_settings[str("player", game_player_no,"_pieces")]

	# Create the buttons for each piece
	for i in range(pieces.size()):
		match pieces[i]["piece"]:
			"knight":
				piece_button = knight_piece.instantiate()
				piece_button.new_name = pieces[i]["piece_name"]
			"farmer":
				piece_button = farmer_piece.instantiate()
				piece_button.new_name = pieces[i]["piece_name"]

		# Place the button equally into the container
		# Size of button is 100 units, and they're seperated by 8 units
		# e.g. 8 (units from edge of container) + i (number of buttons) * 100 (size of button) + 8
		piece_button.position = Vector2(8+(i*(100+8)),0)
		add_child(piece_button)
