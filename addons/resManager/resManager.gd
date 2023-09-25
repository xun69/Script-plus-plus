@tool
extends EditorPlugin


var tscn = preload("res://addons/resManager/main_win.tscn").instantiate()

func _enter_tree():
	add_control_to_bottom_panel(tscn,"资源管理器")
#	menu = add_sys_top_menu("资源管理器",["资源管理器"],func(item_text):
#		match item_text:
#			"资源管理器":
#				var tscn = preload("res://addons/resManager/main_win.tscn")
#				WindowPlugin.show_window_from_tscn(tscn)
#	)
	pass


func _exit_tree():
#	menu.queue_free()
	remove_control_from_bottom_panel(tscn)
	pass
