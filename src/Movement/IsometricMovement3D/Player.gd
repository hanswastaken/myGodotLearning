extends RigidBody3D

@export var movement_speed := 1200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Vector3.ZERO
	input.z = Input.get_axis("move_forward", "move_backward")
	input.x = Input.get_axis("move_left", "move_right")
	apply_central_force(input  * movement_speed * delta)
