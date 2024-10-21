extends Control

var complete = false
var progress = 0
var progress_display = 0

var progress_bar_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Subscribe to sniff events
	Events.connect("sniffed", update_progress_bar)
	
	# Hide the level name after a short time
	var level_name_timer = Timer.new()
	add_child(level_name_timer)
	level_name_timer.one_shot = true
	level_name_timer.start(3.0)
	level_name_timer.timeout.connect(hide_level_name)
	
	# Show progress bar when progress updates
	progress_bar_timer = Timer.new()
	add_child(progress_bar_timer)
	progress_bar_timer.one_shot = true
	progress_bar_timer.timeout.connect(hide_progress_bar)
	
	# Update object name label
	Events.connect("looking_at", show_object_name)
	Events.connect("stop_looking", hide_object_name)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if progress_display < progress:
		progress_display += 1
		$LevelProgressBar/TextureProgressBar.value = progress_display
		progress_bar_timer.start(6.0)
	
	if progress == 100 and not complete:
		progress_bar_timer.stop()
		complete = true
		

func hide_level_name():
	$LevelName/AnimationPlayer.play("hide_level_name")

func update_progress_bar():
	progress = Main.completion_percent
	$LevelProgressBar/AnimationPlayer.play("show_progress_bar")
	
func hide_progress_bar():
	if not complete:
		$LevelProgressBar/AnimationPlayer.play("hide_progress_bar")

func show_object_name(object_name: String):
	$ObjectName.text = object_name
	$ObjectName.visible = true

func hide_object_name():
	$ObjectName.visible = false
