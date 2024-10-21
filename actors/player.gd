extends CharacterBody3D

@export var speed: float = 5.0
@export var acceleration: float = 100.0
@export var camera_sens: float = 1

var mouse_captured: bool = false
var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look
var walk_vel: Vector3
var target: SniffableObject

@onready var camera: Camera3D = $Camera
@onready var sniffcast: RayCast3D = $Sniffcast


func _ready():
	capture_mouse()

func _process(delta):
	if sniffcast.is_colliding():
		var new_target: SniffableObject = sniffcast.get_collider()
		if new_target != target:
			if is_instance_valid(target):
				target.is_being_looked_at = false
			target = new_target
			target.is_being_looked_at = true
	else:
		if is_instance_valid(target):
			target.is_being_looked_at = false
			

func _unhandled_input(event):
	# Handle mouse input for camera movement
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	# Quit game
	if Input.is_action_just_pressed("ui_cancel"):
		release_mouse() if mouse_captured else capture_mouse()

func _physics_process(delta):
	if mouse_captured: _handle_joystick_camera_rotation(delta)
	velocity = _walk(delta)
	move_and_slide()
	
func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera():
	camera.rotation.y -= look_dir.x * camera_sens
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens, -1.5, 1.5)

func _handle_joystick_camera_rotation(delta: float):
	var joypad_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera()
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	# Get the input direction and handle the movement/deceleration.
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var _forward = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel
	
