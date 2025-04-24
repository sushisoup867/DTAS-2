class_name CrouchingPlayerState

extends PlayerMovementState

@export var speed : float = 10.0
@export var crouching_speed : float = 4.0

@onready var shape_cast_3d: ShapeCast3D = %ShapeCast3D

func enter(previous_state) -> void:
	animation.play("crouch", -1.0, crouching_speed)

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed)
	player.update_velocity()
	
	if Input.is_action_just_released("slide"):
		unslide()

func unslide():
	if shape_cast_3d.is_colliding() == false and Input.is_action_pressed("slide") == false:
		animation.play("crouch", -1.0, -crouching_speed * 1.5, true)
		if animation.is_playing():
			await animation.animation_finished
		transition.emit("IdlePlayerState")
	elif shape_cast_3d.is_colliding():
		await get_tree().create_timer(0.1).timeout
		unslide()
