@tool
extends EditorPlugin

var dock = preload("res://addons/myAdd4g4/dock.tscn").instantiate()
var short_struct = preload("res://addons/myAdd4g4/short_struct.tscn").instantiate()
var SceneTreePlugin = preload("res://addons/myAdd4g4/class/sub_class/SceneTreePlugin.gd").new()


func _enter_tree():
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR,dock)
	SceneTreePlugin.add_control_to_Scene_dock_bottom(short_struct)
	pass


func _exit_tree():
	remove_control_from_docks(dock)
	short_struct.queue_free()
	pass
