extends Button

@export var button_icon:Texture2D
@export var draggable_object:PackedScene = preload("res://Scenes/Pieces/knight_piece.tscn")

var is_dragging:bool = false
var knight_piece:Node

var RAYCAST_LENGTH = 1000

var camera:Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the button icon
	icon = button_icon
	
	# Set the object to be created one button select
	knight_piece = draggable_object.instantiate()
	add_child(knight_piece)
	knight_piece.visible = false
	
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
	print("Down")
	is_dragging = true

# Called when button is released (up)
func _on_button_up():
	print("Up")
	is_dragging = false

func get_collided_objects():
	var world = knight_piece.get_world_3d().direct_space_state		# Get the world space the draggable object is in
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()		# Get the current mouse position in the view port
	var start:Vector3 = camera.project_ray_origin(mouse_pos)		# Set start to the mouse position
	var end = camera.project_position(mouse_pos, RAYCAST_LENGTH)	# Set end to the mouse position but at the end of the ray
	var rayCast = PhysicsRayQueryParameters3D.create(start,end)		# Create the query (ray) between start and end
#	rayCast.collide_with_areas = true								# Set the ray to collide with area objects
	rayCast.hit_back_faces = false	
	var results:Dictionary = world.intersect_ray(rayCast)			# Get the collisions between the ray and the objects

	if results.size() > 0:		# We have a hit
		var collided_object:CollisionObject3D = results.get("collider")	# Get the collider of the object
		knight_piece.global_position = Vector3(collided_object.global_position.x, 2, collided_object.global_position.z)
		knight_piece.visible = true
	else:
		knight_piece.visible = false
	
	
	
