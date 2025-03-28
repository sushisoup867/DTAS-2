extends CharacterBody3D

# Import other components
@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D

# Movement variables
var current_speed = 20.0
@export var dashing_speed = 50.0
@export var dash_duration = 0.1
@export var running_speed = 20.0
var jump_velocity = 4.5
var dash_ready: bool = true
var extra_vel = Vector3.ZERO

var mouse_sensitivity = 0.25

# Functions for capturing and releasing the mouse
func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready() -> void:
	capture_mouse()

# Rotates based on mouse movement
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		if is_on_floor():
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		release_mouse()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()

func dash() -> void:
	$DashTimer.wait_time = dash_duration
	$DashTimer.start()
	dash_ready = false

func _on_dash_timer_timeout() -> void:
	dash_ready = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	# Handle dashing.
	if Input.is_action_just_pressed("dash") and dash_ready:
		dash()
	if $DashTimer.time_left > 0:
		velocity += -transform.basis.z
	
	# Get the input direction and handle the movement/deceleration.~
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
