extends PanelContainer
@onready var property_container = %VBoxContainer
var property

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
	add_debug_property("Stamina", "0")

func _process(delta):
	property.text = property.name + ": " + str(Global.player.current_stamina)

func _input(event):
	if event.is_action_pressed("debug_menu"):
		visible = !visible

func add_debug_property(title : String, value):
	property = Label.new()
	property_container.add_child(property)
	property.name = title
	property.text = property.name + value
