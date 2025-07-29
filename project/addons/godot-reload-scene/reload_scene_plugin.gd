@tool
extends EditorPlugin

var toolbar

func _enter_tree():
	#toolbar = preload("reload_scene.tscn").instance()
	toolbar = preload("reload_scene.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_control_to_container(CONTAINER_TOOLBAR, toolbar)

#	refresher.connect("request_refresh_plugin", self, "_on_request_refresh_plugin")
#	refresher.connect("confirm_refresh_plugin", self, "_on_confirm_refresh_plugin")


func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, toolbar)
	toolbar.free()

func get_plugin_name():
	return "Reload-Scene"
