extends PanelContainer
@onready var property_container = %VBoxContainer
var property

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Global.debug_panel = self

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("debug_menu"):
		visible = !visible

func add_debug_property(title : String, value, order):
	var target
	target = property_container.find_child(title,true,false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = target.name + ": " + str(value)
		property_container.move_child(target, order)
