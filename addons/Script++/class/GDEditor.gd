# ========================================================
# 名称：GDEditor - Godot4.0版
# 类型：
# 简介：扩展的编辑器插件开发类，可用于更好更快的开发编辑器插件
# 此版本另辟蹊径，简化了很多代码，只提供一些基础的界面元素引用和函数
# 更多的EditorPlugin、EditorInterFace、CodeEdit的函数将不再重复映射
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023年4月2日19:16:57
# 最后修改时间：2023年4月20日22:37:41
# ========================================================



@tool
extends EditorPlugin
#class_name GDEditor

## 返回对EditorInterface的引用
var face:EditorInterface
## 返回EditorInterface.get_tree().root
var face_root:Window
## 返回EditorInterface.get_base_control()
var base_control:Panel
## 返回对编辑器顶部栏的引用
var editor_title_bar:HBoxContainer
## 返回对编辑器顶部菜单栏的引用
var top_menu_bar:MenuBar

var scenes_tabbar:TabBar
var add_new_scene_button:Button
var focus_mode_button:Button



## 返回对2D场景编辑器界面的引用。[br]
## [method EditorPlugin.add_control_to_container]提供了2D场景编辑器的几个位点，更建议使用。
## 提供的位点可参考：[enum EditorPlugin.CustomControlContainer]。
var main_screen_CanvasItemEditor

## 返回对3D场景编辑器界面的引用。[br]
## EditorPlugin的add_control_to_container()提供了3D场景编辑器的几个位点，更建议使用。
var main_screen_Node3DEditor

## 返回对脚本编辑器界面的引用。[br]
## EditorPlugin以及EditorInterface对脚本编辑器位点的引用支持较弱，因此也是本扩展类重点编写的部分。[br]
## 请查看本类提供的相关属性和方法，并使用他们来创建你的脚本相关插件。
var main_screen_ScriptEditor

## 返回对AssetLib界面的引用。
var main_screen_EditorAssetLibrary

## 返回 - 脚本编辑器界面 - 管理和显示多个脚本以及帮助文档的TabContainer控件。[br]
## 通过它你可以获得当前打开的脚本或者帮助的索引等信息。
var ScriptEditor_TabContainer:TabContainer

## 返回 - 脚本编辑器界面 - 顶部栏的HBoxContainer。
## 包括脚本菜单部分和其他按钮部分。
var ScriptEditor_topbar:HBoxContainer

var ScriptEditor_R_vbox:VBoxContainer  # 脚本编辑器右侧VBox - 脚本编辑框
var ScriptEditor_LU_Vbox:VBoxContainer # 脚本编辑器左上角VBox - 脚本列表
var ScriptEditor_LB_Vbox:VBoxContainer # 脚本编辑器左上角VBox - 方法列表


func _init():
	# 初始化部分界面元素引用
	face = get_editor_interface()
	face_root = face.get_tree().root
	base_control = face.get_base_control()
	
	var base_vbox:VBoxContainer = get_child_as_class(base_control,"VBoxContainer")
	
	editor_title_bar = get_child_as_class(base_vbox,"EditorTitleBar")
	top_menu_bar = editor_title_bar.get_child(0)
	
	var main_vbox:VBoxContainer = get_child_by_indexPath(base_vbox,[1, 1, 1, 0])
	scenes_tabbar = get_child_by_indexPath(main_vbox,[0, 0, 0, 0, 0, 0])
	add_new_scene_button = get_child_by_indexPath(main_vbox,[0, 0, 0, 0, 0, 0, 0])
	focus_mode_button = get_child_by_indexPath(main_vbox,[0, 0, 0, 0, 0, 3])
	
	var main_screen = get_child_by_indexPath(main_vbox,[0, 0, 0, 1, 0])
	
	main_screen_CanvasItemEditor = get_child_as_class(main_screen,"CanvasItemEditor")
	main_screen_Node3DEditor = get_child_as_class(main_screen,"Node3DEditor")
	main_screen_ScriptEditor = face.get_script_editor()
	main_screen_EditorAssetLibrary = get_child_as_class(main_screen,"EditorAssetLibrary")
	
	ScriptEditor_LU_Vbox = get_child_by_indexPath(main_screen_ScriptEditor,[0, 1, 0, 0])
	ScriptEditor_LB_Vbox = get_child_by_indexPath(main_screen_ScriptEditor,[0, 1, 0, 1])
	
	ScriptEditor_R_vbox = get_child_by_indexPath(main_screen_ScriptEditor,[0, 1, 1])
	ScriptEditor_topbar = get_child_by_indexPath(main_screen_ScriptEditor,[0, 0])
	ScriptEditor_TabContainer = get_child_as_class(ScriptEditor_R_vbox,"TabContainer")


# 返回当前场景的选中节点
func get_current_scene_select() -> Node:
	return face.get_selection().get_selected_nodes()[0] if face.get_selection().get_selected_nodes().size() >0 else null



# 返回当前场景的路径
func get_current_scene_path() -> String:
	var arr = face.get_open_scenes()
	return arr[scenes_tabbar.current_tab]

## 通过indexPath指定的层级索引，查找并返回node的后代节点。
## 例如:[code]get_child_by_indexPath(Lab1,[0,0])[/code]返回Lab1节点第一个子节点的第一个子节点。
func get_child_by_indexPath(node:Node,indexPath:PackedInt32Array) -> Node:
	for idx in indexPath:
		var nd = node.get_child(idx)
		node = nd
	return node	

## 返回node对应类名的一级子节点。
## 例如：[code]get_child_as_class(Lab1,"TextEdit")[/code]返回Lab1节点下类名为"TextEdit"的第一个控件。
func get_child_as_class(node:Node,className:String):
	var children = node.get_children()
	for child in children:
		if child.get_class() == className:
			return child

# =================================== 辅助函数 ===================================
# 获取classType类型的图标
func get_icon(classType:String) -> Texture2D:
	return base_control.get_theme_icon(classType, "EditorIcons")

# 将classType类型的图标保存到save_path
func save_class_icon_to_png(calssType:String,save_path:String,size := Vector2(20,20)) -> void:
	var icon:Texture2D = get_icon(calssType)
	var img = icon.get_image()
	# 图标尺寸缩小为20×20
	img.resize(size.x,size.y,Image.INTERPOLATE_NEAREST)
	img.save_png(save_path)
	update_file_sys_dock()

# 返回当前日期时间字符串
# 形如： YYYY-MM-DD HH:MM:SS
static func Now() -> String:
	return Time.get_datetime_string_from_system(false,true).replace("T"," ")

# 返回引擎当前版本信息
static func engine_version() ->String:
	return Engine.get_version_info()["string"]

# 返回"文件系统"面板当前选中文件所在的文件夹的路径
# 如果选中文件夹，则返回其自身的路径
func get_file_sys_dock_current_dir() -> String:
	return face.get_current_directory()

# 文件系统面板执行更新
func update_file_sys_dock():
	face.get_resource_filesystem().scan() 

# 编辑file_path指定的资源
# 如果是纯文本则用内部编辑器打开
func edit_resource(file_path:String):
	face.edit_resource(load(file_path))

# 编辑file_path指定的资源
# 如果是纯文本则用内部编辑器打开
func edit_node(node:Node):
	face.edit_node(node)

# 切换主屏幕
func change_to_mainscreen(mainscreen_name:String) -> void:
	face.set_main_screen_editor(mainscreen_name)
