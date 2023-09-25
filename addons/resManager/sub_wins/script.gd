# ========================================================
# 名称：脚本分组管理器
# 类型：
# 简介：专用于脚本的分组和分类管理
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-27 19:41:39
# 最后修改时间：2023-04-27 19:41:39
# ========================================================
@tool
extends HSplitContainer

# =================================== 依赖 ===================================
var GDEditor = preload("res://addons/resManager/class/GDEditor.gd").new()
var SceneTreePlugin = preload("res://addons/resManager/class/sub_class/SceneTreePlugin.gd").new()
var myConfig = preload("res://addons/resManager/lib/myConfig.gd")

# 场景分组文件
const script_groups_path = "res://addons/resManager/data/script_groups.cfg" 

# =================================== 节点引用 ===================================
@onready var item_groups = %ItemGroups
@onready var code_txt = %codeTxt



func _ready():
# 添加场景分组列表
	load_groups()
		
# =================================== 加载和保存数据 ===================================
# 将存储的在.cfg文件中的分组信息加载到场景管理器
func load_groups():
	if FileAccess.file_exists(script_groups_path):
		var dict = myConfig.load_config_as_dic(script_groups_path)
		
		for gup in dict:
#			print(JSON.stringify(dict[gup],"\t"))
			var g = item_groups.add_group(dict[gup]["gup_title"])
			for itm in dict[gup]["items"]:
				get_preview_texture(itm,func(preview):
					g.add_item(itm.get_file(),preview if preview else GDEditor.get_icon("PackedScene"))
					g.set_item_metadata(g.get_item_count()-1,itm)
				)

# 将分组和分组下的元素信息保存到指定的.cfg文件中
func save_groups_info():
	var dict = {}
	for i in item_groups.get_groups_count():
		var gup = item_groups.get_group(i)
		var gup_dict = {}
		gup_dict["gup_title"] = gup.title
		gup_dict["items"] = []
		for j in gup.get_item_count():
			gup_dict["items"].append(gup.get_item_metadata(j))
		dict["group_%s" % (i+1)] = gup_dict
	myConfig.save_dic_as_config(script_groups_path,dict)

# =================================== 获取资源预览图 ===================================
# 获取指定路径res_path的资源的预览图
# call_back返回一个参数preview，即获得的预览图
func get_preview_texture(res_path:String,call_back:Callable):
	var texture
	var plugin = EditorPlugin.new()
	var face = plugin.get_editor_interface()
	var pr = face.get_resource_previewer()
	pr.queue_resource_preview(res_path,self, "_preview", func(preview, thumbnail_preview):
		call_back.call(preview)
	)
	
# 由get_preview_texture()调用
func _preview(path: String, preview: Texture2D, thumbnail_preview: Texture2D, userdata: Callable):
	userdata.call(preview, thumbnail_preview)

# =================================== 信号处理 ===================================
# 添加分组按钮 - 点击
func _on_add_scene_group_btn_pressed():
	# 添加场景分组列表
	item_groups.add_group("未命名分组")
	save_groups_info()

# ItemGroups - 通过拖放添加项后
func _on_item_groups_drop_item_added(files, gup_index):
	save_groups_info()


# ItemGroups - 重命名分组标题后
func _on_item_groups_title_renamed(new_title, gup_index):
	save_groups_info()


# ItemGroups - 项被选中或单击时
func _on_item_groups_item_clicked(path):
	var sc:Script = load(path)
	# 显示脚本内容
	code_txt.text = sc.source_code


# ItemGroups - 项被双击时
func _on_item_groups_item_dbl_click(path):
	var face:EditorInterface = GDEditor.face
	face.edit_script(load(path))


# ItemGroups - 项被删除时后
func _on_item_groups_items_deleted():
	save_groups_info()

# ItemGroups - 分组被删除后
func _on_item_groups_removed_group():
	save_groups_info()
