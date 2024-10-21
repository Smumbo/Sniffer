extends Node

enum ControlMethod {KBM, GAMEPAD}
var curr_control_method: ControlMethod

var total_sniffable_objects: int
var objects_sniffed: int = 0
var completion_percent: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	total_sniffable_objects = len(get_tree().get_nodes_in_group("sniffable"))
	Events.connect("sniffed", sniffed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Set current control method for input prompts based on last input
func _input(event):
	if (event is InputEventKey):
		curr_control_method = ControlMethod.KBM
	elif (event is InputEventMouse):
		curr_control_method = ControlMethod.KBM
	elif (event is InputEventJoypadButton):
		curr_control_method = ControlMethod.GAMEPAD
	elif (event is InputEventJoypadMotion):
		curr_control_method = ControlMethod.GAMEPAD

func sniffed():
	objects_sniffed += 1
	completion_percent = (float(objects_sniffed) / total_sniffable_objects) * 100
