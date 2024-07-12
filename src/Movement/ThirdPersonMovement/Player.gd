extends CharacterBody3D

const HORIZONTAL_LOOK_SPEED = 0.1
const VERTICAL_LOOK_SPEED = 0.05
const SPEED = 5.0
const SENSITIVITY = 0.1
const JUMP_VELOCITY = 4.5

@onready var pivot = $CameraPivot

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	controller_look()

	move_and_slide()

func controller_look():
	var look_horizontal = Input.get_axis("look_right", "look_left")
	var look_vertical = Input.get_axis("look_up", "look_down")
	rotate_y(look_horizontal * HORIZONTAL_LOOK_SPEED)
	pivot.rotate_x(look_vertical * VERTICAL_LOOK_SPEED)
	pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		pivot.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
