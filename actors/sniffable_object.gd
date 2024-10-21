extends Area3D
class_name SniffableObject

@export var sniffed = false
@export var object_name: String
@export var sniff_time: float = 1.0
@export var fog: FogVolume

var is_being_looked_at

@onready var timer: Timer = $HoldTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sniffed:
		pass
	
	if is_being_looked_at and Input.is_action_just_pressed("sniff"):
		timer.start(sniff_time)
	if not timer.is_stopped():
		if not is_being_looked_at:
			timer.stop()
		if Input.is_action_just_released("sniff"):
			timer.stop()


func _on_timer_timeout():
	sniffed = true
	var fog_material: FogMaterial = fog.material
	fog_material.density = 0.0
	print("Sniffed " + object_name)
