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
	if is_targeted and not object_sniffed:
		if object_sniffed:
			Events.emit_signal("looking_at", object_name)
		elif Input.is_action_just_pressed("sniff"):
			timer.start(sniff_time)
	if not timer.is_stopped():
		if not is_targeted:
			timer.stop()
		if Input.is_action_just_released("sniff"):
			timer.stop()


func _on_timer_timeout():
	Events.emit_signal("sniffed")
	object_sniffed = true
	var fog_material: FogMaterial = fog.material
	fog_material.density = 0.0
	print("Sniffed " + object_name)

func set_targeted(value: bool):
	is_targeted = value
	if is_targeted and object_sniffed:
		Events.emit_signal("looking_at", object_name)
	elif not is_targeted and object_sniffed:
		Events.emit_signal("stop_looking")
	
