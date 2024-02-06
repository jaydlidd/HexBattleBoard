extends Label

var piece_count: int
var total_count: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	piece_count = GlobalVars.get_piece_count(1)
	total_count = GlobalVars.get_total_pieces(1)
	
	text = "{x}/{y}".format({"x":piece_count, "y":total_count})

#func add_piece(piece:PackedScene):
#	# Add a piece to the count
