extends Area3D
class_name SniffableObject

@export var object_sniffed = false
@export var object_name: String
@export var sniff_time: float = 1.0
@export var fog: FogVolume

var is_targeted: bool = false

@onready var timer: Timer = $HoldTimer

func _ready():
	timer.connect("timeout", _on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_targeted and not object_sniffed and Input.is_action_just_pressed("sniff"):
		timer.start(sniff_time)
	if not timer.is_stopped():
		if not is_targeted:
			timer.stop()
			Events.emit_signal("hide_prompt")
		if Input.is_action_just_released("sniff"):
			timer.stop()


func _on_timer_timeout():
	Events.emit_signal("sniffed")
	Events.emit_signal("hide_prompt")
	object_sniffed = true
	var fog_material: FogMaterial = fog.material
	fog_material.density = 0.0
	print("Sniffed " + object_name)

func set_targeted(value: bool):
	is_targeted = value
	if is_targeted:
		if object_sniffed:
			Events.emit_signal("show_name", object_name)
		else:
			Events.emit_signal("show_prompt")
	else:
		Events.emit_signal("hide_prompt")
		if object_sniffed:
			Events.emit_signal("hide_name")
	
