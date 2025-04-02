extends CharacterBody3D


@export var speed = 5.0
@export var jump_velocity = 4.5

@export var MOUSE_SENSITIVITY : float = 0.6
@export var LOWER_TILT_LIMIT := deg_to_rad(-90)
@export var UPPER_TILT_LIMIT := deg_to_rad(90)
@onready var CAMERA_CONTROLLER: Camera3D = $CameraController/Camera3D

var mouse_input : bool = false
var mouse_rotation : Vector3
var rotation_input : float
var tilt_input : float
var player_rotation : Vector3
var camera_rotation : Vector3

func _input(event):
	if Input.is_action_pressed("exit"):
		get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func update_camera(delta):
	mouse_rotation.x += tilt_input * delta
	if is_on_floor():
		mouse_rotation.x = clamp(mouse_rotation.x, LOWER_TILT_LIMIT, UPPER_TILT_LIMIT)
	mouse_rotation.y += rotation_input * delta
	
	player_rotation = Vector3(0.0, mouse_rotation.y, 0.0)
	camera_rotation = Vector3(mouse_rotation.x, 0.0, 0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(player_rotation)
	
	rotation_input = 0.0
	tilt_input = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Makes camera rotate when mouse moves
	update_camera(delta)
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
