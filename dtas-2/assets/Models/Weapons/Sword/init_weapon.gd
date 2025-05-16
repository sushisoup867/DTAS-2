@tool

extends Node3D

@export var weapon_type : Weapons:
	set(value):
		weapon_type = value
		if Engine.is_editor_hint():
			load_weapon()

const SWORD = preload("res://assets/Models/Weapons/Sword/sword.tres")
const MORDHAU = preload("res://assets/Models/Weapons/Mordhau/mordhau.tres")
const PISTOL = preload("res://assets/Models/Weapons/Pistol/pistol.tres")

@onready var weapon_mesh: MeshInstance3D = %WeaponMesh

func _ready() -> void:
	load_weapon()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('weapon1'):
		weapon_type = SWORD
		load_weapon()
	if event.is_action_pressed("weapon2"):
		weapon_type = MORDHAU
		load_weapon()
	if event.is_action_pressed("weapon3"):
		weapon_type = PISTOL
		load_weapon()

func load_weapon() -> void:
	weapon_mesh.mesh = weapon_type.mesh
	position = weapon_type.position
	rotation_degrees = weapon_type.rotation
	scale = weapon_type.scale
