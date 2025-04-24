class_name SlidingPlayerState

extends PlayerMovementState

@export var speed : float = 20.0
@export var slide_anim_speed : float = 4.0
@export var tilt_amount : float = 0.09

@onready var shape_cast_3d: ShapeCast3D = %ShapeCast3D

func enter(previous_state) -> void:
	set_tilt(player._current_rotation)

func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	tilt.z = clamp(tilt_amount * player_rotation, -0.1, 0.1)
	if tilt.z == 0.0:
		tilt.z == 0.05
