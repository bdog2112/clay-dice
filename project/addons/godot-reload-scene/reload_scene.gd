#-------------------------------------------------------------------------------
# reload_scene.gd
#
# OVERVIEW
# When editing plugins, the user must, often, change screens to view results.
# They also frequently find that the scene has stopped responding and it must be
# reloaded. This utility is designed to help speed up the reloading process.
#
# BASIC FUNCTIONS
# To reload a scene, the user sets some options and then presses a "Reload"
# button. The two options are: 1 Save Scene before reload, 2 Switch screen on
# reload.
#
# HOW IT WORKS
# When reload is pressed, the following tasks are performed:
# - get the current scene
# - save scene (optional)
# - reload scene
# - switch screen
#
# NOTE: Addon used to select previously selected node. But, Godot 4.4.x does
# that on its own. Hence, that feature has been removed.
#
# This addon was built to work in tandem with "godot-plugin-refresher". If you
# haven't tried it, then consider giving it a try in your addon development.
#
# FUTURE POSSIBILITIES:
# - Select a specific script in Script Editor.
# - Go to specific line number in Script Editor.
#-------------------------------------------------------------------------------
@tool
extends HBoxContainer

enum Screen {
	NONE,
	TWO_D,
	THREE_D,
	SCRIPT,
}
const SCREEN_LIST = ["None", "2D", "3D", "Script"]
var _eds = EditorScript.new()
var _edi = _eds.get_editor_interface()
@onready var btn_reload = $BtnReload
@onready var opt_chg_screen = $OptChgScreen
@onready var chk_save: CheckBox = $ChkSave


func _ready():
	if get_tree().edited_scene_root == self:
		return # This is the scene opened in the editor!

	btn_reload.icon = ThemeDB.get_default_theme().get_icon("reload", "FileDialog")
	for screen in SCREEN_LIST:
		opt_chg_screen.add_item(screen)
	#var type_list := ThemeDB.get_default_theme().get_icon_type_list()
	#for theme_type in type_list:
		#var icon_list := ThemeDB.get_default_theme().get_icon_list(theme_type)
		#print("theme_type: %s\n%s" % [theme_type, icon_list])

func _on_BtnReload_pressed():
	# GET CURRENT SCENE
	var root = get_tree().edited_scene_root
	if root:
		# SAVE SCENE
		if chk_save.button_pressed:
			_edi.save_scene()
		# RELOAD SCENE
		var scenefile = root.scene_file_path
		_edi.reload_scene_from_path(scenefile)
	# SWITCH SCREEN
	match opt_chg_screen.selected:
		Screen.NONE:
			pass
		Screen.TWO_D:
			#print("2D")
			_edi.call_deferred("set_main_screen_editor", "2D")
		Screen.THREE_D:
			#print("3D")
			_edi.call_deferred("set_main_screen_editor", "3D")
		Screen.SCRIPT:
			#print("Script")
			_edi.call_deferred("set_main_screen_editor", "Script")
			# SELECT SCRIPT
			# GOTO LINE NUMBER
	#print(Time.get_ticks_msec())
