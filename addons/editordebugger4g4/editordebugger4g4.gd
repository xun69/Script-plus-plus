# *****************************************************
# EditorDebugger For Godot 4 - 插件代码
# 作者：巽星石
# Godot版本： v4.0.1.stable.official [cacf49999]
# 创建时间：2023年3月30日16:26:53
# 最后修改时间：2023年3月30日22:27:09
# 描述：自己重新设计，用于方便Godot 4.0编辑器插件编写
# *****************************************************

@tool
extends EditorPlugin

var dock = preload("res://addons/editordebugger4g4/main.tscn").instantiate()

func _enter_tree():
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL,dock)
	pass


func _exit_tree():
	remove_control_from_docks(dock)
	pass
