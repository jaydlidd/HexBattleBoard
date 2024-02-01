extends Node3D

# Variables
var draggable = false
var is_inside_tile = false
var body_ref
var offset: Vector3
var initialPos: Vector3

var mouse = Vector2.ZERO

var camera: Camera3D
#
func _input(event):
	# Update the mouse vector to follow the actual mouse movement
	if event is InputEventMouseMotion:
		mouse = event.position

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the active camera
	camera = get_viewport().get_camera_3d()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_selection()
	if draggable:
		if Input.is_action_just_pressed("mouse_click"):
			initialPos = global_position
			
#			offset = GameManager.get_global_mouse_pos() - global_position
		if Input.is_action_pressed("mouse_click"):
#			print(GameManager.get_global_mouse_pos_x(), 0, GameManager.get_global_mouse_pos_y())
#			global_position = GameManager.get_global_mouse_pos() - offset
#			print(mouse)
			global_position = Vector3 (GameManager.get_global_mouse_pos_x(), 1, GameManager.get_global_mouse_pos_y())
		elif Input.is_action_just_released("mouse_click"):
			var tween = get_tree().create_tween()
			if is_inside_tile:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				draggable = false
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
				draggable = false

func _on_area_3d_body_entered(body):
	if body.is_in_group("Droppable"):
		is_inside_tile = true
		body_ref = body

func _on_area_3d_body_exited(body):
	if body.is_in_group("Droppable"):
		is_inside_tile = false

func _on_area_3d_mouse_entered():
	draggable = true
	scale = Vector3(1.05, 1.05, 1.05)

func _on_area_3d_mouse_exited():
	scale = Vector3(1, 1, 1)
	
# Handle ray casting and getting a global position for the mouse
func get_selection():
	# Get the current World3d which is just the current scene essentially
	var worldspace = get_world_3d().direct_space_state
	
	# Start projecting a ray from the current mouse position
	var start = camera.project_ray_origin(mouse)
	
	# Get a point 1000 units from the mouse
	var end = camera.project_position(mouse, 1000)
	
	# Create a PhysicsRayQueryParameters3D to hold the raycast and so we can set parameters
	var rayParams = PhysicsRayQueryParameters3D.new()
	
	# Set the params
	rayParams.from = start
	rayParams.to = end
	rayParams.exclude = []
	rayParams.collision_mask = 1
	rayParams.collide_with_areas = true
	
	# Project the ray and get where it intersects first	
	var result = worldspace.intersect_ray(rayParams)
#	print(result)
	if result.size() != 0:
		# If there is an interaction with on object, ground / player, then update mouse pos
		mouse.x = result.position.x
		mouse.y = result.position.z
		GameManager.set_global_mouse_pos(mouse)
