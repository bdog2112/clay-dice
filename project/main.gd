# CLAY DICE
extends Node3D

enum DIE_TYPE {
	D4,
	D6,
	D8,
	D10,
	D12,
	D20,
}
const DICE_TIMER_DURATION := 1.75
const D20_VALUES: Dictionary = {0:2, 1:20, 2:12, 3:10, 4:8, 5:14, 6:18, 7:15,
	8:17, 9:16, 10:4, 11:5, 12:7, 13:3, 14:6, 15:11, 16:13, 17:1, 18:19, 19:9}
const D6_VALUES: Dictionary = {0:4, 2:2, 4:3, 6:5, 8:6, 10:1}
const DICE_PHYSICS_MATERIAL: PhysicsMaterial = preload("res://materials/dice_physics_material.tres")
const D6: PackedScene = preload("res://scenes/dice/d6.tscn")
const D20: PackedScene = preload("res://scenes/dice/d20.tscn")
@export var number_of_dice := 3
@export var current_die_type := DIE_TYPE.D20
var tween: Tween
var timer: Timer = Timer.new()
var dice_values := D6_VALUES
@onready var dice: Node3D = $Dice
@onready var result: Label = $Control/Results

## Get it started
func _ready() -> void:
	# Setup dice
	change_dice(current_die_type, true)
	# Setup dice settling/result timer
	add_child(timer)
	start_dice_timer()
	timer.timeout.connect(check_for_off_kilter_dice)


## Get inputs from player
func _input(event: InputEvent) -> void:

	if Input.is_key_pressed(KEY_ESCAPE) and not Engine.is_editor_hint():
		get_tree().quit(0)

	elif Input.is_action_just_pressed("toggle_fullscreen"):
		var window := get_window()
		if window.mode == Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
		else:
			window.mode = Window.MODE_FULLSCREEN

	elif Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

	elif Input.is_action_just_pressed("choose_d4"):
		change_dice(DIE_TYPE.D4)

	elif Input.is_action_just_pressed("choose_d6"):
		change_dice(DIE_TYPE.D6)

	elif Input.is_action_just_pressed("choose_d8"):
		change_dice(DIE_TYPE.D8)

	elif Input.is_action_just_pressed("choose_d10"):
		change_dice(DIE_TYPE.D10)

	elif Input.is_action_just_pressed("choose_d12"):
		change_dice(DIE_TYPE.D12)

	elif Input.is_action_just_pressed("choose_d20"):
		change_dice(DIE_TYPE.D20)

	elif Input.is_action_just_pressed("add_die"):
		var total_dice := dice.get_child_count() + 1
		if total_dice <= 8:
			add_die()
			number_of_dice = total_dice

	elif Input.is_action_just_pressed("remove_die"):
		var total_dice := dice.get_child_count() - 1
		if total_dice > 0:
			remove_die()
			number_of_dice = total_dice


## Roll dice and deal with any physics issues
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


## Adds a single die to the scene
func add_die():
	var main_die: Node3D = dice.get_child(0)
	var new_die := main_die.duplicate(DUPLICATE_USE_INSTANTIATION)
	dice.add_child(new_die)
	var die_rigid = new_die.get_child(0)
	roll_single_die(die_rigid)


## Removes the last die in the list
func remove_die():
	var num_dice := dice.get_child_count()
	# Don't remove if there's only one die
	if num_dice == 1:
		return
	# Remove the last die in the list
	var die_idx := num_dice - 1
	var die_to_remove := dice.get_child(die_idx)
	dice.remove_child(die_to_remove)
	die_to_remove.queue_free()
	check_for_off_kilter_dice()


## Changes type of die based on an enum
func change_dice(die_type: DIE_TYPE, purge_dice: bool = false):
	# Bail if die type is already active
	print("current_die_type %s, die_type %s" % [current_die_type, die_type])
	if current_die_type == die_type and not purge_dice:
		return
	current_die_type = die_type
	# Clear existing dice
	for ch in dice.get_children():
		dice.remove_child(ch)
		ch.queue_free()
	# Determine new die type
	var die_scene: Node3D
	match die_type:
		DIE_TYPE.D6:
			die_scene = D6.instantiate()
			dice_values = D6_VALUES
		DIE_TYPE.D20:
			die_scene = D20.instantiate()
			dice_values = D20_VALUES
		_:
			die_scene = D20.instantiate()
			dice_values = D20_VALUES
	# Add die to scene and setup properties
	dice.add_child(die_scene)
	var main_die_rigid: RigidBody3D = die_scene.get_child(0)
	main_die_rigid.physics_material_override = DICE_PHYSICS_MATERIAL
	main_die_rigid.gravity_scale = 0.9
	# The following properties are for test purposes.
	# They may or may not be needed...
	#main_die_rigid.inertia = Vector3(0.83, 0.83, 0.83)
	#main_die_rigid.angular_damp = 0.1
	#main_die_rigid.linear_damp = 0.05
	main_die_rigid.mass = 2.0

	# Add remaining dice
	var num_dice_to_add := number_of_dice - dice.get_child_count()
	for die in num_dice_to_add:
		add_die()


## Check for anomalous dice and re-roll them
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
	var top_i = -1

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
			top_i = i
	var face_value: int = dice_values[top_face_index]
	return face_value
	#print("indices size %s" % indices.size())
	#print("top_face_index %s, max_dot %s, top_i %s" % [top_face_index, max_dot, top_i])
	#print("top_face_index %s" % [top_face_index])
	#return top_face_index


## Rolls all of the dice.
func roll_dice():
	for child in dice.get_children():
		var die = child.get_children()[0]
		roll_single_die(die)


## Rolls a single die in a random direction with a random spin.
func roll_single_die(die):
		var offset := 12.0
		var spin: Vector2 = Vector2(100, 200)
		var x_offset = randf_range(-offset, offset)
		var z_offset = randf_range(-offset, offset)
		var x_spin = randf_range(spin.x, spin.y) * [-1, 1].pick_random()
		var y_spin = randf_range(spin.x, spin.y) * [-1, 1].pick_random()
		var z_spin = randf_range(spin.x, spin.y) * [-1, 1].pick_random()
		var speed := randf_range(-6, -4)
		var dir := Vector3(x_offset, speed, z_offset)
		var torque := Vector3(x_spin, y_spin, z_spin)
		die.global_position = Vector3(0,.5, 0)
		die.rotation = Vector3.ZERO
		die.apply_impulse(dir)
		die.apply_torque(torque)
		start_dice_timer()


func start_dice_timer():
	result.text = "Dice Settling..."
	timer.start(DICE_TIMER_DURATION)


## Automate dice rolling for test purposes.
func start_tween():
	tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_interval(0.5)
	tween.tween_callback(roll_dice)
