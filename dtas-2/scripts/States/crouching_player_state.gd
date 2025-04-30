class_name CrouchingPlayerState

extends PlayerMovementState

@export var speed : float = 10.0
@export var crouching_speed : float = 4.0

@onready var shape_cast_3d: ShapeCast3D = %ShapeCast3D

var released: bool = false

func enter(previous_state) -> void:
	if previous_state.name != 'SlidingPlayerState':
		animation.play("crouch", -1.0, crouching_speed)
	else:
		animation.current_animation = 'crouch'
		animation.seek(1.0, true)

func exit():
	released = false

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed)
	player.update_velocity()
	
	if Input.is_action_just_released("slide"):
		unslide()
	elif Input.is_action_pressed('slide') == false and released == false:
		released = true
		unslide()
	
	if Input.is_action_just_pressed('jump') and player.is_on_floor():
		transition.emit('JumpingPlayerState')

func unslide():
	if shape_cast_3d.is_colliding() == false and Input.is_action_pressed("slide") == false:
		animation.play("crouch", -1.0, -crouching_speed * 1.5, true)
		if animation.is_playing():
			await animation.animation_finished
		transition.emit("IdlePlayerState")
	elif shape_cast_3d.is_colliding():
		await get_tree().create_timer(0.1).timeout
		unslide()
