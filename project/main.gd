# CLAY DICE
extends Node3D
@onready var twenty: RigidBody3D = $"Clay Dice 01/twenty-rigid"

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
		# Throw dice
		print("%s throw dice" % Time.get_ticks_msec())
		var x_offset = randi_range(-100, 100) * 0.1
		var y_offset = randi_range(-100, 100) * 0.1
		twenty.global_position = Vector3(0,.5, 0)
		twenty.apply_impulse(Vector3(x_offset,-5, y_offset))
		pass
