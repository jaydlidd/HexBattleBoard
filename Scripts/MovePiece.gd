extends Button

@export var button_icon:Texture2D
@export var draggable_object:PackedScene = preload("res://Scenes/Pieces/knight_piece.tscn")

var is_dragging:bool = false
var knight_piece:Node

var RAYCAST_LENGTH = 1000

var camera:Camera3D

var collided_object_id:int

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
	is_dragging = true

# Called when button is released (up)
func _on_button_up():
	is_dragging = false
	var last_node = find_last_hit_node()
	
	# We found the node, so check if the space is occupied
	if last_node.is_occupied == false:
		# If so, set it to occupied
		last_node.is_occupied = true
	# If not, remove the piece and give the piece back
	else:
		knight_piece.visible = false

func get_collided_objects():
	var world = knight_piece.get_world_3d().direct_space_state		# Get the world space the draggable object is in
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()		# Get the current mouse position in the view port
	var start:Vector3 = camera.project_ray_origin(mouse_pos)		# Set start to the mouse position
	var end = camera.project_position(mouse_pos, RAYCAST_LENGTH)	# Set end to the mouse position but at the end of the ray
	var rayCast = PhysicsRayQueryParameters3D.create(start,end)		# Create the query (ray) between start and end
	var results:Dictionary = world.intersect_ray(rayCast)			# Get the collisions between the ray and the objects

	if results.size() > 0:		# We have a hit
		var collided_object:CollisionObject3D = results.get("collider")		# Get the collider of the object
		collided_object_id = results.get("collider_id")						# Get the ID of the collider
		knight_piece.global_position = Vector3(collided_object.global_position.x, 2, collided_object.global_position.z)
		knight_piece.visible = true
	else:
		knight_piece.visible = false

func find_last_hit_node():
	var scene_child_count = get_tree().current_scene.get_child_count()	# Get the number of children in the root node
	var scene_children = get_tree().current_scene.get_children()		# Get the root node's children
	
	# For each of the root node's children
	for i in range(scene_child_count):
		var current_children_of_node = scene_children[i].get_children()			# Get the current node's children
		var current_child_count_of_node = scene_children[i].get_child_count()	# Get the current node's count of children

		# For each of the current children of the child of the root node
		for j in range(current_child_count_of_node):
			# If the instance ID of this node matches the collider ID
			if current_children_of_node[j].get_instance_id() == collided_object_id:
				return current_children_of_node[j]
				
