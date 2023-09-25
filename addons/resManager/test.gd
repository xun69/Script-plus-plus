@tool
extends EditorScript


var sys_menu = SysMenuPlugin.new()
func _run():
	sys_menu.add_sys_top_menu("aaa",["ddd"],func(item):
		print(item)
	)
	pass
