# ========================================================
# 名称：Script++
# 类型：编辑器插件 GDEditor扩展类型
# 简介：专用于编辑器脚本功能增强，例如：
#       - 快速添加各种注释
#       - 快速导出为HTML
#       - 快速导出MarkDown文档
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-09 16:56:23
# 最后修改时间：2023-04-09 16:56:23
# ========================================================

@tool
extends "class/sub_class/ScriptPlugin.gd"

var my_menubar = preload("res://addons/Script++/UIs/script_menu_bar.tscn").instantiate()
#var script_list_btns = preload("res://addons/Script++/UIs/script_list_btns.tscn").instantiate()
func _enter_tree():
	# 加载自定义的脚本编辑器顶部菜单项目
	add_control_behind_ScriptEditor_menus(my_menubar)
	pass


func _exit_tree():
	my_menubar.queue_free()
	pass
