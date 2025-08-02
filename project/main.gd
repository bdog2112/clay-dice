# CLAY DICE
# Copyright (C) 2025 BDOG2112
extends Node3D

enum DIE_TYPE {
	D4,
	D6,
	D8,
	D10,
	D12,
	D20,
}
const DICE_TIMER_DURATION := 0.75 # 1.75
#const D4_VALUES: Dictionary = {2:1, 0:2, 3:3, 1:4} # non-beveled
const D4_VALUES: Dictionary = {2:1, 1:2, 0:3, 91:4} # beveled
#const D6_VALUES: Dictionary = {0:4, 2:2, 4:3, 6:5, 8:6, 10:1} # non-beveled
const D6_VALUES: Dictionary = {4:1, 8:2, 2:3, 6:4, 0:5, 186:6} # beveled
const D8_VALUES: Dictionary = {5:1, 0:2, 3:3, 187:4, 2:5, 6:6, 1:7, 4:8} # beveled
#const D10_VALUES: Dictionary = {0:1, 18:2, 6:3, 12:4, 8:5, 10:6, 4:7, 16:8, 2:9, 14:0} # non-beveled
const D10_VALUES: Dictionary = {4:1, 18:2, 2:3, 10:4, 6:5, 8:6, 16:7, 14:8, 0:9, 12:10}
const D12_VALUES: Dictionary = {3:1, 27:2, 0:3, 12:4, 30:5, 33:6, 24:7, 21:8, 15:9, 6:10, 18:11, 9:12} # beveled
#const D20_VALUES: Dictionary = {0:2, 1:20, 2:12, 3:10, 4:8, 5:14, 6:18, 7:15,
	#8:17, 9:16, 10:4, 11:5, 12:7, 13:3, 14:6, 15:11, 16:13, 17:1, 18:19, 19:9} # non-beveled
const D20_VALUES: Dictionary = {16:1, 2:2, 9:3, 5:4, 7:5, 13:6, 8:7, 3:8, 18:9,
	 1:10, 14:11, 475:12, 15:13, 6:14, 10:15, 12:16, 11:17, 4:18, 17:19, 0:20} # beveled
const GENERIC_VALUES: Dictionary = {0:0, 1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9, 10:10, 11:11, 12:12, 13:13, 14:14, 15:15, 16:16, 17:17, 18:18, 19:19, 20:20, 21:21, 22:22, 23:23, 24:24, 25:25, 26:26, 27:27, 28:28, 29:29, 30:30, 31:31, 32:32, 33:33, 34:34, 35:35, 36:36, 37:37, 38:38, 39:39, 40:40, 41:41, 42:42, 43:43, 44:44, 45:45, 46:46, 47:47, 48:48, 49:49, 50:50, 51:51, 52:52, 53:53, 54:54, 55:55, 56:56, 57:57, 58:58, 59:59, 60:60, 61:61, 62:62, 63:63, 64:64, 65:65, 66:66, 67:67, 68:68, 69:69, 70:70, 71:71, 72:72, 73:73, 74:74, 75:75, 76:76, 77:77, 78:78, 79:79, 80:80, 81:81, 82:82, 83:83, 84:84, 85:85, 86:86, 87:87, 88:88, 89:89, 90:90, 91:91, 92:92, 93:93, 94:94, 95:95, 96:96, 97:97, 98:98, 99:99, 100:100, 101:101, 102:102, 103:103, 104:104, 105:105, 106:106, 107:107, 108:108, 109:109, 110:110, 111:111, 112:112, 113:113, 114:114, 115:115, 116:116, 117:117, 118:118, 119:119, 120:120, 121:121, 122:122, 123:123, 124:124, 125:125, 126:126, 127:127, 128:128, 129:129, 130:130, 131:131, 132:132, 133:133, 134:134, 135:135, 136:136, 137:137, 138:138, 139:139, 140:140, 141:141, 142:142, 143:143, 144:144, 145:145, 146:146, 147:147, 148:148, 149:149, 150:150, 151:151, 152:152, 153:153, 154:154, 155:155, 156:156, 157:157, 158:158, 159:159, 160:160, 161:161, 162:162, 163:163, 164:164, 165:165, 166:166, 167:167, 168:168, 169:169, 170:170, 171:171, 172:172, 173:173, 174:174, 175:175, 176:176, 177:177, 178:178, 179:179, 180:180, 181:181, 182:182, 183:183, 184:184, 185:185, 186:186, 187:187, 188:188, 189:189, 190:190, 191:191, 192:192, 193:193, 194:194, 195:195, 196:196, 197:197, 198:198, 199:199, 200:200, 201:201, 202:202, 203:203, 204:204, 205:205, 206:206, 207:207, 208:208, 209:209, 210:210, 211:211, 212:212, 213:213, 214:214, 215:215, 216:216, 217:217, 218:218, 219:219, 220:220, 221:221, 222:222, 223:223, 224:224, 225:225, 226:226, 227:227, 228:228, 229:229, 230:230, 231:231, 232:232, 233:233, 234:234, 235:235, 236:236, 237:237, 238:238, 239:239, 240:240, 241:241, 242:242, 243:243, 244:244, 245:245, 246:246, 247:247, 248:248, 249:249, 250:250, 251:251, 252:252, 253:253, 254:254, 255:255, 256:256, 257:257, 258:258, 259:259, 260:260, 261:261, 262:262, 263:263, 264:264, 265:265, 266:266, 267:267, 268:268, 269:269, 270:270, 271:271, 272:272, 273:273, 274:274, 275:275, 276:276, 277:277, 278:278, 279:279, 280:280, 281:281, 282:282, 283:283, 284:284, 285:285, 286:286, 287:287, 288:288, 289:289, 290:290, 291:291, 292:292, 293:293, 294:294, 295:295, 296:296, 297:297, 298:298, 299:299, 300:300, 301:301, 302:302, 303:303, 304:304, 305:305, 306:306, 307:307, 308:308, 309:309, 310:310, 311:311, 312:312, 313:313, 314:314, 315:315, 316:316, 317:317, 318:318, 319:319, 320:320, 321:321, 322:322, 323:323, 324:324, 325:325, 326:326, 327:327, 328:328, 329:329, 330:330, 331:331, 332:332, 333:333, 334:334, 335:335, 336:336, 337:337, 338:338, 339:339, 340:340, 341:341, 342:342, 343:343, 344:344, 345:345, 346:346, 347:347, 348:348, 349:349, 350:350, 351:351, 352:352, 353:353, 354:354, 355:355, 356:356, 357:357, 358:358, 359:359, 360:360, 361:361, 362:362, 363:363, 364:364, 365:365, 366:366, 367:367, 368:368, 369:369, 370:370, 371:371, 372:372, 373:373, 374:374, 375:375, 376:376, 377:377, 378:378, 379:379, 380:380, 381:381, 382:382, 383:383, 384:384, 385:385, 386:386, 387:387, 388:388, 389:389, 390:390, 391:391, 392:392, 393:393, 394:394, 395:395, 396:396, 397:397, 398:398, 399:399, 400:400, 401:401, 402:402, 403:403, 404:404, 405:405, 406:406, 407:407, 408:408, 409:409, 410:410, 411:411, 412:412, 413:413, 414:414, 415:415, 416:416, 417:417, 418:418, 419:419, 420:420, 421:421, 422:422, 423:423, 424:424, 425:425, 426:426, 427:427, 428:428, 429:429, 430:430, 431:431, 432:432, 433:433, 434:434, 435:435, 436:436, 437:437, 438:438, 439:439, 440:440, 441:441, 442:442, 443:443, 444:444, 445:445, 446:446, 447:447, 448:448, 449:449, 450:450, 451:451, 452:452, 453:453, 454:454, 455:455, 456:456, 457:457, 458:458, 459:459, 460:460, 461:461, 462:462, 463:463, 464:464, 465:465, 466:466, 467:467, 468:468, 469:469, 470:470, 471:471, 472:472, 473:473, 474:474, 475:475, 476:476, 477:477, 478:478, 479:479, 480:480, 481:481, 482:482, 483:483, 484:484, 485:485, 486:486, 487:487, 488:488, 489:489, 490:490, 491:491, 492:492, 493:493, 494:494, 495:495, 496:496, 497:497, 498:498, 499:499, 500:500}
const DICE_PHYSICS_MATERIAL: PhysicsMaterial = preload("res://materials/dice_physics_material.tres")
const D4: PackedScene = preload("res://scenes/dice/d4.tscn")
const D6: PackedScene = preload("res://scenes/dice/d6.tscn")
const D8: PackedScene = preload("res://scenes/dice/d8.tscn")
const D12: PackedScene = preload("res://scenes/dice/d12.tscn")
const D10: PackedScene = preload("res://scenes/dice/d10.tscn")
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
	#start_tween() # Auto-roll quickly for test purposes


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
		DIE_TYPE.D4:
			die_scene = D4.instantiate()
			dice_values = D4_VALUES
		DIE_TYPE.D6:
			die_scene = D6.instantiate()
			dice_values = D6_VALUES
		DIE_TYPE.D8:
			die_scene = D8.instantiate()
			dice_values = D8_VALUES
		DIE_TYPE.D10:
			die_scene = D10.instantiate()
			dice_values = D10_VALUES
			#dice_values = GENERIC_VALUES
		DIE_TYPE.D12:
			die_scene = D12.instantiate()
			dice_values = D12_VALUES
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
	main_die_rigid.mass = 6.0

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
		var up_dir := Vector3.UP
		if current_die_type in [DIE_TYPE.D4]:
			up_dir = Vector3.DOWN
		var dot = world_normal.dot(up_dir)

		# Update max_dot if this face is more upward-facing. Ignore beveled and
		# duplicate faces. i.e. Every die face has 2 tris. Ignore the 2nd tri.
		if dot > max_dot and face_index in dice_values:
			max_dot = dot
			top_face_index = face_index
			top_i = i
	var face_value: int = dice_values[top_face_index]
	# Pause and verify that face value matches visual value
	#if face_value in [4,14]:
		#pass
	return face_value


## Rolls all of the dice.
func roll_dice():
	for child in dice.get_children():
		var die = child.get_children()[0]
		roll_single_die(die)


## Rolls a single die in a random direction with a random spin.
func roll_single_die(die: RigidBody3D):
		var offset := 12.0
		var spin: Vector2 = Vector2(100, 200)
		var x_offset = randf_range(-offset, offset)
		var z_offset = randf_range(-offset, offset)
		var x_spin = randf_range(spin.x, spin.y) * [-1, 1].pick_random()
		var y_spin = randf_range(spin.x, spin.y) * [-1, 1].pick_random() * 0.1
		var z_spin = randf_range(spin.x, spin.y) * [-1, 1].pick_random()
		var speed := randf_range(-6, -4)
		var dir := Vector3(x_offset, speed, z_offset)
		var torque := Vector3(x_spin, y_spin, z_spin)
		die.global_position = Vector3(0,.5, 0)
		die.rotation = Vector3.ZERO
		die.apply_impulse(dir)
		die.apply_torque_impulse(torque)
		start_dice_timer()


func start_dice_timer():
	result.text = "Dice Settling..."
	timer.start(DICE_TIMER_DURATION)


## Automate dice rolling for test purposes.
func start_tween():
	tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_interval(DICE_TIMER_DURATION + 0.05)
	tween.tween_callback(roll_dice)

# Copyright (C) 2025 BDOG2112
