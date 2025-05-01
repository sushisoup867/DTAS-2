class_name JumpingPlayerState

extends PlayerMovementState

@export var speed : float = 10.0
@export var jump_velocity : float = 10.5
@export var double_jump_velocity : float = 10.5
@export var input_mult : float = 0.95
var wall_jump_force : float = 4.0

var double_jump : bool = false

func enter(previous_state):
	player.velocity.y += jump_velocity
	speed = previous_state.speed
	animation.play('jump_start')

func exit() -> void:
	double_jump = false

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed * input_mult)
	player.update_velocity()
	
	if Input.is_action_just_pressed('jump') and !double_jump:
		player.velocity.y = double_jump_velocity
		animation.play('jump_start')
		double_jump = true
	if Input.is_action_just_pressed('slide'):
		player.velocity.y = -75
	
	if player.is_on_floor():
		animation.play('jump_end')
		transition.emit('IdlePlayerState')
