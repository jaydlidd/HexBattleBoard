extends RigidBody3D
var velocity
var direction:String = "up"
var SPEED = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity = Vector3.ZERO
	if direction == "up":
		while position.x < 5:
			velocity += Vector3.UP * SPEED * delta
		direction = "down"
	elif direction == "down":
		while position.x > 0.5:
			velocity += Vector3.DOWN * SPEED * delta
		direction = "up"
