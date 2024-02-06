extends Button

# Editor variables
@export var button_icon:Texture2D
@export var draggable_object:PackedScene

var is_dragging:bool = false	# To monitor if currently dragging the piece
var piece:Node					# Reference to the object

var RAYCAST_LENGTH = 1000

var camera:Camera3D

var collided_object_id
var new_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the button icon
	icon = button_icon
	
	await get_tree().create_timer(2).timeout
	piece = draggable_object.instantiate()		# Set the object to be created one button select
	add_child(piece)
	piece.visible = false
#	piece.name = str(piece.get_instance_id())
	piece.name = new_name
	print(piece.name)
	
	# Get the camera in scene
	camera = get_viewport().get_camera_3d()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# If currently dragging object
	if is_dragging:
		# Find mouse position and raycast down until we hit an object
		get_collided_objects()

# Called when button is down
func _on_button_down():
	is_dragging = true
	self.self_modulate.a = 0

# Called when button is released (up)
func _on_button_up():
	is_dragging = false
	var last_node = GlobalVars.find_node_by_id(collided_object_id)
	
	if last_node != null:
		# We found the node, so check if the space is occupied
		if last_node.is_occupied == false:
			# If so, set it to occupied
			last_node.is_occupied = true
		# If not, remove the piece and give the piece back
		else:
			self.self_modulate.a = 1
			piece.global_position = Vector3(0, 0, 0)
			piece.visible = false
	else:
		self.self_modulate.a = 1
		piece.global_position = Vector3(0, 0, 0)
		piece.visible = false

func get_collided_objects():
	var world = piece.get_world_3d().direct_space_state				# Get the world space the draggable object is in
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()		# Get the current mouse position in the view port
	var start:Vector3 = camera.project_ray_origin(mouse_pos)		# Set start to the mouse position
	var end = camera.project_position(mouse_pos, RAYCAST_LENGTH)	# Set end to the mouse position but at the end of the ray
	var rayCast = PhysicsRayQueryParameters3D.create(start,end)		# Create the query (ray) between start and end
	var results:Dictionary = world.intersect_ray(rayCast)			# Get the collisions between the ray and the objects

	if results.size() > 0:		# We have a hit
		var collided_object:CollisionObject3D = results.get("collider")		# Get the collider of the object
		collided_object_id = results.get("collider_id")						# Get the ID of the collider
		piece.global_position = Vector3(collided_object.global_position.x, 2, collided_object.global_position.z)
		piece.visible = true
	else:
		piece.global_position = Vector3(0, 0, 0)
		piece.visible = false
		collided_object_id = null					# Set the ID to null to reset the last hit object

# Function to name a board piece with a globally unique name on spawn
func set_global_piece_name():
	if "knight" in button_icon.load_path:
		piece.name = str(GlobalVars.total_pieces) + "knight"
	if "farmer" in button_icon.load_path:
		piece.name = str(GlobalVars.total_pieces) + "farmer"
