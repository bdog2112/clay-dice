# CLAY DICE
extends Node3D
@onready var clay_dice_01: Node3D = $"Dice/Clay Dice 01"
@onready var dice: Node3D = $Dice

func _ready() -> void:
	for i in range(3):
		var new_die := clay_dice_01.duplicate(DUPLICATE_USE_INSTANTIATION)
		dice.add_child(new_die)


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
		for child in dice.get_children():
			var die = child.get_children()[0]
			throw_dice(die)


## Throws a single die in a random direction with a random spin.
func throw_dice(die):
		var offset := 12.0
		var spin := 10.0
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
