class_name IdlePlayerState

extends PlayerMovementState

@export var speed : float = 10.0

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed)
	player.update_velocity()
	
	if Input.is_action_just_pressed("slide") and player.is_on_floor():
		transition.emit("CrouchingPlayerState")
	if player.velocity.length() > 0.0 and Global.player.is_on_floor():
		if Input.is_action_pressed("sprint"):
			transition.emit("SprintingPlayerState")
		else:
			transition.emit("WalkingPlayerState")
