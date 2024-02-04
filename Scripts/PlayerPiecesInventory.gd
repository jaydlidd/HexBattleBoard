extends HBoxContainer

var game_player_no = 1
var knight_piece:PackedScene = preload("res://Scenes/UI/Knight_Piece_Button.tscn")
var piece_button:Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get this player's pieces
	var pieces:Array = GlobalVars.game_settings[str("player", game_player_no,"_pieces")]
	
	# Create the buttons for each piece
	for i in range(pieces.size()):
		piece_button = knight_piece.instantiate()
		piece_button.position = Vector2(8+(i*(100+8)),0)
		add_child(piece_button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
