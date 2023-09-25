# ========================================================
# 名称：SceneTreePlugin
# 类型：插件扩展类
# 简介：专用于“场景”面板插件开发的类
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-12 00:26:45
# 最后修改时间：2023年4月20日22:42:20
# ========================================================
@tool
#class_name SceneTreePlugin
extends "../GDEditor.gd"


# "场景"面板
var Scene_dock
# "场景"面板 - SceneTreeEditor
var scene_tree_editor
# "场景"面板 - 节点树 - Tree控件
var Scene_dock_Tree


func _init():
	super._init()
	Scene_dock = face_root.find_child("Scene",true,false) 
	scene_tree_editor = get_child_as_class(Scene_dock,"SceneTreeEditor")
	Scene_dock_Tree = get_child_as_class(scene_tree_editor,"Tree")


# ========================= 场景结构相关 =========================

# 返回当前场景的节点结构字典
func get_current_scene_nodes_dic() -> Dictionary:
	var dict:Dictionary = get_node_structure_dic(face.get_edited_scene_root())
	dict["scene_path"] = get_current_scene_path()
	return dict

# 返回当前场景选中节点的结构字典
func get_select_node_dic() -> Dictionary:
	var dict:Dictionary = get_node_structure_dic(get_current_scene_select())
	dict["scene_path"] = get_current_scene_path()
	return dict

# ========================= 底层函数 =========================
func get_node_structure_dic(node:Node) -> Dictionary:
	var dic = {}
	dic["name"] = node.name
	dic["class_name"] = node.get_class()
	dic["script_path"] = node.get_script().resource_path if node.get_script() else ""
	# 遍历子节点
	var childs = node.get_children()
	dic["children"] = []
	for child in childs:
		dic["children"].append(get_node_structure_dic(child))
	return dic


func add_control_to_Scene_dock_bottom(control:Control):
	Scene_dock.add_child(control)
	



