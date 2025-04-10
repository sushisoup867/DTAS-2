class_name Player
extends CharacterBody3D

# Import other components
@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Movement variables
var current_speed = 20.0
@export var jump_velocity = 10.5
@export var running_speed = 20.0
var ant_gravity_multiplier = 2.0

@export var max_stamina := 100.0
var current_stamina = max_stamina
@export var stamina_recharge_rate := 5.0

var dash_direction = Vector3.ZERO
var dashing : bool = false
@export var dashing_speed = 50.0
@export var dash_duration = 0.1
@export var dash_cost = 33

var is_sliding : bool = false
@export_range(5, 10, 0.1) var slide_anim_speed : float = 1.0

var mouse_sensitivity = 0.25

# Functions for capturing and releasing the mouse
func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready() -> void:
	capture_mouse()
	Global.player = self

# Rotates head and character based on mouse movement
func _input(event):
	# Rotate camera
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		if is_on_floor():
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	# Handle sliding.
	if event.is_action_pressed("slide"):
		animation_player.play("slide", -1, slide_anim_speed, true)
	else:
		animation_player.play("slide", -1, -slide_anim_speed)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		release_mouse()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()

# Dash function
func dash(last_direction) -> void:
	if not dashing and current_stamina > dash_cost:
		$DashTimer.wait_time = dash_duration
		if last_direction:
			dash_direction = last_direction
		else:
			dash_direction = -transform.basis.z
		$DashTimer.start()
		dashing = true
		current_stamina -= dash_cost

func _on_dash_timer_timeout() -> void:
	dashing = false

# Handles stamina regen
func _on_stamina_timer_timeout() -> void:
	if current_stamina < max_stamina:
		current_stamina += stamina_recharge_rate
	
	if current_stamina > max_stamina:
		current_stamina = max_stamina
	elif current_stamina < 0:
		current_stamina = 0

# Add current stamina to hud/debug panel
func _process(_delta):
	Global.debug_panel.add_debug_property("Stamina", current_stamina, 1)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * ant_gravity_multiplier
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	# Handle dashing.
	if Input.is_action_just_pressed("dash") and not dashing:
		dash(direction)
	if $DashTimer.time_left > 0:
		velocity = dash_direction * dashing_speed
	
	# Handle movement/deceleration
	if not dashing:
		if direction:
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
