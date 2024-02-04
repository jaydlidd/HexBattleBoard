extends CharacterBody3D

@export var SPEED = 10000.0
@export var ZOOM_SPEED = 100.0
@export var MAX_HEIGHT = 30.0
@export var MIN_HEIGHT = 5.0

@onready var camera = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity = Vector3.ZERO
	
#	# Handle WASD key use for camera movement
	if Input.is_action_pressed("move_right"):
		velocity += Vector3.BACK * SPEED * delta
	if Input.is_action_pressed("move_left"):
		velocity += Vector3.FORWARD * SPEED * delta
	if Input.is_action_pressed("move_down"):
		velocity += Vector3.LEFT * SPEED * delta
	if Input.is_action_pressed("move_up"):
		velocity += Vector3.RIGHT * SPEED * delta
			
	move_and_slide()
