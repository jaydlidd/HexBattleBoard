extends HBoxContainer

var piece_button:Node
var count = 0
var game_player_no

# Pieces preloaded
var knight_piece:PackedScene = preload("res://Scenes/UI/Knight_Piece_Button.tscn")
var farmer_piece:PackedScene = preload("res://Scenes/UI/Farmer_Piece_Button.tscn")

# Called when the node enters the scene tree for the first time.
#func _ready():
#	await get_tree().create_timer(1).timeout		# Wait to begin building the inventory for the pieces to be added
#	# Get this player's pieces
#	var pieces:Dictionary = GlobalVars.game_settings[str(game_player_no) + "_inventory"]
#
#	# Create the buttons for each piece
#	for current_piece in pieces:
#		match pieces[current_piece]["piece_type"]:
#			"knight":
#				piece_button = knight_piece.instantiate()	# Spawn the button
#				piece_button.new_name = current_piece		# Name the piece by the provided name in the inventory
#			"farmer":
#				piece_button = farmer_piece.instantiate()	# Spawn the button
#				piece_button.new_name = current_piece		# Name the piece by the provided name in the inventory
#
#		# Place the button equally into the container
#		# Size of button is 100 units, and they're seperated by 8 units
#		# e.g. 8 (units from edge of container) + i (number of buttons) * 100 (size of button) + 8
#		count += 1
#		piece_button.position = Vector2(8+(count*(100+8)),0)
#		add_child(piece_button)
