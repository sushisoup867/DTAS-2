class_name SprintingPlayerState

extends PlayerMovementState

@export var speed : float = 20.0

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed)
	player.update_velocity()
	
	if Input.is_action_just_pressed('jump') and player.is_on_floor:
		transition.emit('JumpingPlayerState')
	
	if Input.is_action_just_pressed("slide") and player.is_on_floor():
		transition.emit("SlidingPlayerState")
		
	if Input.is_action_just_released("sprint") or player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
	
	if player.velocity.y < -3 and !player.is_on_floor():
		transition.emit('FallingPlayerState')
