class_name TheMimic

extends Node

@export var current_state : State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("ayo that's not a state :skull_emoji:")
	await owner.ready
	current_state.enter()

func _process(delta):
	current_state.update(delta)
	Global.debug_panel.add_debug_property("Current State", current_state.name, 1)

func _physics_process(delta):
	current_state.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state:
			current_state.exit()
			new_state.enter(current_state)
			current_state = new_state
	else:
		push_warning("tf that's not a state dumbass")
