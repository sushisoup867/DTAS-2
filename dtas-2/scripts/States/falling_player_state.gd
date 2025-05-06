class_name FallingPlayerState

extends PlayerMovementState

@export var speed: float = 5.0
@export var double_jump_velocity: float = 10.5

var double_jump: bool = false

func enter(previous_state) -> void:
	animation.pause()

func exit():
	double_jump = false

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed)
	player.update_velocity()
	
	if Input.is_action_just_pressed('jump') and !double_jump:
		player.velocity.y = double_jump_velocity
		animation.play('jump_start')
		double_jump = true
	if Input.is_action_just_pressed('slide'):
		player.velocity.y = -75
	if player.is_on_floor():
		animation.play('jump_end')
		transition.emit("IdlePlayerState")
