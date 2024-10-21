extends Node

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

func sniffed():
	objects_sniffed += 1
	completion_percent = (objects_sniffed / total_sniffable_objects) * 100
