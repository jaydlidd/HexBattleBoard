extends Button

# Editor variables
@export var button_icon:Texture2D
@export var draggable_object:PackedScene

# Piece variables
var is_dragging:bool = false
var piece:Node
var collided_object_id
var new_name: String
var taken_piece: Dictionary

# Camera / raycasting variables
var RAYCAST_LENGTH = 1000
var camera:Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = button_icon							# Set the button icon
	
	await get_tree().create_timer(2).timeout	# Allows for inventory setup before creating buttons
	piece = draggable_object.instantiate()		# Set the object to be created one button select
	add_child(piece)							# Add the piece to the scene
	piece.visible = false						# Make the piece invisible for now
	piece.name = new_name						# Name the piece to allow for easy reference
	
	camera = get_viewport().get_camera_3d()		# Get the camera in scene
	
	GlobalVars.game_settings["is_loading"] = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# If currently dragging object
	if is_dragging:
		get_collided_objects()		# Find mouse position and raycast down until we hit an object

# Function for handling when button is down (clicked)
func _on_button_down():
	is_dragging = true									# Set the piece to dragging
	self.self_modulate.a = 0.3							# Make the button invisible
	taken_piece = GlobalVars.take_piece(1, piece.name)	# Take the piece from the player's inventory
	print(taken_piece)

# Called when button is released (up)
func _on_button_up():
	
	is_dragging = false												# Set the piece to dragging
	var last_node = GlobalVars.find_node_by_id(collided_object_id)	# Find the node under the mouse
	print(last_node)
	
	if last_node != null and last_node.is_occupied == false:		# If last_node is not null and map tile is empty
		last_node.is_occupied = true								# Set tile to occupied
		self.disabled = true										# Disable piece button
	else:
		return_piece_to_player()									# Give the piece back
		
# Function to return piece to player inventory.
# 	Used when piece is not properly placed or if map tile is already occupied.
func return_piece_to_player():
	GlobalVars.add_piece(1, taken_piece.piece_type, taken_piece.piece_name)	# Add piece to player inventory
	self.self_modulate.a = 1												# Make the button invisible
	piece.global_position = Vector3(0, 0, 0)								# Reset the piece position
	piece.visible = false													# Make the piece invisible again
	self.disabled = false													# Re-enable button

# Function for raycasting from mouse position to find the map tile under the mouse
func get_collided_objects():
	var world = piece.get_world_3d().direct_space_state				# Get the world space the draggable object is in
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()		# Get the current mouse position in the view port
	var start:Vector3 = camera.project_ray_origin(mouse_pos)		# Set start to the mouse position
	var end = camera.project_position(mouse_pos, RAYCAST_LENGTH)	# Set end to the mouse position but at the end of the ray
	var rayCast = PhysicsRayQueryParameters3D.create(start,end)		# Create the query (ray) between start and end
	var results:Dictionary = world.intersect_ray(rayCast)			# Get the collisions between the ray and the objects

	if results.size() > 0:		# We have a hit
		var collided_object:CollisionObject3D = results.get("collider")												# Get the collider of the object
		collided_object_id = results.get("collider_id")																# Get the ID of the collider
		piece.global_position = Vector3(collided_object.global_position.x, 2, collided_object.global_position.z)	# Set the global position of the piece to the map tile found
		piece.visible = true																						# Make the piece visible
	else:
		piece.global_position = Vector3(0, 0, 0)	# Reset the piece position
		piece.visible = false						# Hide the piece
		collided_object_id = null					# Set the ID to null to reset the last hit object

# Function to name a board piece with a globally unique name on spawn
func set_global_piece_name():
	if "knight" in button_icon.load_path:
		piece.name = str(GlobalVars.total_pieces) + "knight"
	if "farmer" in button_icon.load_path:
		piece.name = str(GlobalVars.total_pieces) + "farmer"
