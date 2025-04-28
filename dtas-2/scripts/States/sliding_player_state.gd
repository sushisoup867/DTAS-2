class_name SlidingPlayerState

extends PlayerMovementState

@export var speed : float = 20.0
@export var slide_anim_speed : float = 4.0
@export var tilt_amount : float = 0.09

@onready var shape_cast_3d: ShapeCast3D = %ShapeCast3D

func enter(previous_state) -> void:
	set_tilt(player._current_rotation)
	animation.get_animation('Sliding').track_set_key_value(4, 0, player.velocity.length())
	animation.speed_scale = 1.0
	animation.play('Sliding', -1.0, slide_anim_speed)

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed)
	player.update_velocity()

func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	tilt.z = clamp(tilt_amount * player_rotation, -0.1, 0.1)
	if tilt.z == 0.0:
		tilt.z == 0.05
	animation.get_animation('Sliding').track_set_key_value(8, 1, tilt)
	animation.get_animation('Sliding').track_set_key_value(8, 2, tilt)

func finish():
	transition.emit("CrouchingPlayerState")
