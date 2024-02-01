extends StaticBody3D

var camera: Camera3D
var mouse: Vector2 = Vector2.ZERO

func _input(event):
	# Update the mouse vector to follow the actual mouse movement
	if event is InputEventMouseMotion:
		mouse = event.position

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_viewport().get_camera_3d()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_selection()
#	pass

# Handle ray casting and getting a global position for the mouse
func get_selection():
	# Get the current World3d which is just the current scene essentially
	var worldspace = get_world_3d().direct_space_state
	
	# Start projecting a ray from the current mouse position
	var start = camera.project_ray_origin(mouse)
	
	# Get a point 1000 units from the mouse
	var end = camera.project_position(mouse, 100000)
	
	# Create a PhysicsRayQueryParameters3D to hold the raycast and so we can set parameters
	var rayParams = PhysicsRayQueryParameters3D.new()
	
	# Set the params
	rayParams.from = start
	rayParams.to = end
	rayParams.exclude = []
	rayParams.collision_mask = 1
	rayParams.hit_from_inside = true
#	rayParams.collide_with_areas = true
	
	# Project the ray and get where it intersects first	
	var result = worldspace.intersect_ray(rayParams)
	print(result)
	if result.size() != 0:
		# If there is an interaction with on object, ground / player, then update mouse pos
		mouse.x = result.position.x
		mouse.y = result.position.z
		GameManager.set_global_mouse_pos(mouse)
