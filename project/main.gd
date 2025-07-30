# CLAY DICE
extends Node3D
const DICE_TIMER_DURATION := 2
const D20_VALUES: Dictionary = {0:2, 1:20, 2:12, 3:10, 4:8, 5:14, 6:18, 7:15,
	8:17, 9:16, 10:4, 11:5, 12:7, 13:3, 14:6, 15:11, 16:13, 17:1, 18:19, 19:9}
var tween: Tween
var timer: Timer = Timer.new()
@onready var clay_dice_01: Node3D = $"Dice/Clay Dice 01"
@onready var dice: Node3D = $Dice
@onready var result: Label = $Control/Results

func _ready() -> void:
	# Setup dice
	for i in range(3):
		var new_die := clay_dice_01.duplicate(DUPLICATE_USE_INSTANTIATION)
		dice.add_child(new_die)
	# Setup timer
	add_child(timer)
	start_dice_timer()
	timer.timeout.connect(check_for_off_kilter_dice)


func _input(event: InputEvent) -> void:

	if Input.is_key_pressed(KEY_ESCAPE) and not Engine.is_editor_hint():
		get_tree().quit(0)

	if Input.is_action_just_pressed("toggle_fullscreen"):
		var window := get_window()
		if window.mode == Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
		else:
			window.mode = Window.MODE_FULLSCREEN

	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept"):
		roll_dice()
		#start_tween()

	# Fix glitched dice. If a die's Y-position
	# is below nominal distance, then re-roll.
	for child in dice.get_children():
		var die: RigidBody3D = child.get_children()[0]
		if die.global_position.y < -0.25:
			roll_single_die(die)
			if tween:
				tween.kill()
			break


func check_for_off_kilter_dice():
	timer.stop()
	var new_result: String = "Result: "
	for child in dice.get_children():
		var die: RigidBody3D = child.get_child(0)
		var meshi: MeshInstance3D = die.get_child(0)
		var die_value := get_die_value(meshi)
		new_result += str(die_value) + "   "
		if die.global_position.y > 0.099:
			roll_single_die(die)
			start_dice_timer()
	if timer.is_stopped():
		result.text = new_result


## Identifies top face index and looks up face value in a dictionary.
func get_die_value(meshi: MeshInstance3D)->int:
	var mesh = meshi.mesh

	# Get mesh data
	var arrays = mesh.surface_get_arrays(0)
	var indices = arrays[Mesh.ARRAY_INDEX]
	var normals = arrays[Mesh.ARRAY_NORMAL]

	if not indices or not normals:
		return -1

	# Track most upward face
	var max_dot = -1.0
	var top_face_index = -1

	# Process each face/triangle
	for i in range(0, indices.size(), 3):
		var face_index = i / 3 # Unique index for each face
		# Get the normal of the first vertex of the triangle (assuming flat shading)
		var normal = normals[indices[i]]
		# Transform normal to world space to account for rotation
		var world_normal = meshi.global_transform.basis * normal
		# Calculate dot product with global up vector
		var dot = world_normal.dot(Vector3.UP)

		# Update if this face is more upward-facing
		if dot > max_dot:
			max_dot = dot
			top_face_index = face_index
	var face_value: int = D20_VALUES[top_face_index]
	return face_value


## Rolls all of the dice.
func roll_dice():
	for child in dice.get_children():
		var die = child.get_children()[0]
		roll_single_die(die)
	start_dice_timer()


## Rolls a single die in a random direction with a random spin.
func roll_single_die(die):
		var offset := 12.0
		var spin := 8.0
		var x_offset = randf_range(-offset, offset)
		var z_offset = randf_range(-offset, offset)
		var x_spin = randf_range(-spin, spin)
		var y_spin = randf_range(-spin, spin)
		var z_spin = randf_range(-spin, spin)
		var speed := randf_range(-6, -4)
		var dir := Vector3(x_offset, speed, z_offset)
		var torque := Vector3(x_spin, y_spin, z_spin)
		die.global_position = Vector3(0,.5, 0)
		die.rotation = Vector3.ZERO
		die.apply_impulse(dir)
		die.apply_torque(torque)


func start_dice_timer():
	result.text = "Dice Settling..."
	timer.start(DICE_TIMER_DURATION)


## Automate dice rolling for test purposes.
func start_tween():
	tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_interval(0.5)
	tween.tween_callback(roll_dice)
