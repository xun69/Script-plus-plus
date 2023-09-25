# ========================================================
# 名称：资产管理器 - 主界面
# 类型：
# 简介：
# 作者：
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-23 20:48:20
# 最后修改时间：2023-04-23 20:48:20
# ========================================================
@tool
extends HSplitContainer
# =================================== 依赖 ===================================
var GDEditor = preload("res://addons/resManager/class/GDEditor.gd").new()
var SceneTreePlugin = preload("res://addons/resManager/class/sub_class/SceneTreePlugin.gd").new()
var myConfig = preload("res://addons/resManager/lib/myConfig.gd")

# 场景分组文件
const tscn_groups_path = "res://addons/resManager/data/tscn_groups.cfg" 

# =================================== 节点引用 ===================================
@onready var res_type_list = %resTypeList
@onready var tabs = %Tabs


func _ready():
	# 添加左侧资源类型列表
	res_type_list.clear()
	var res_types = [
		["PackedScene","场景"],
		["GDScript","脚本"],
#		["Object","资源"],
		["TextureRect","图片"],
		["AudioStreamMP3","音频"],
		["Mesh","数据"],
		["Help","文档"],
		["EditorPlugin","插件"],
	]
	
	for type in res_types:
		res_type_list.add_item(type[1],GDEditor.get_icon(type[0]))
	res_type_list.select(0)

# 左侧列表项点击 - 右侧选项卡切换
func _on_res_type_list_item_selected(index):
	if index < tabs.get_tab_count():
		tabs.current_tab = index
