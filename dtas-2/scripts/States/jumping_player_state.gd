class_name JumpingPlayerState

extends PlayerMovementState

@export var speed : float = 10.0
@export var jump_velocity : float = 10.5
@export var input_mult : float = 0.95
var wall_jump_force : float = 4.0

func enter(previous_state):
	player.velocity.y += jump_velocity
	animation.pause()

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed * input_mult)
	player.update_velocity()
	
	if player.is_on_floor():
		transition.emit('IdlePlayerState')
