# ========================================================
# 名称：ItemList
# 类型：ItemList扩展
# 简介：接收来自“文件系统”面板的文件拖放并生成图标
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-24 00:39:34
# 最后修改时间：2023-04-24 00:39:34
# ========================================================
@tool
extends ItemList
signal drop_item_added(files) # 通过拖放添加项后触发

## 允许ItemList拖放的后缀类型
@export var filters:PackedStringArray = []

# =================================== 拖放虚函数处理 ===================================
# 只接收来自“文件系统”面板的拖放 - 且限定只有单个或多个文件才能放
func _can_drop_data(at_position, data):
	return data["type"] == "files" # 限定只有文件才能放

# 接收来自“文件系统”面板的拖放
func _drop_data(at_position, data):
	var files:PackedStringArray = data["files"]
	for file in files:
		if file.get_extension() in filters: # 限定只有指定后缀类型才能被添加
			get_preview_texture(file,func(preview):
				add_item(file.get_file(),preview)
				set_item_metadata(item_count-1,file)
			)
	emit_signal("drop_item_added",[files])

func _get_drag_data(at_position):
	var dict = {"type":"files","files":[]}
	var idxs:PackedInt32Array = get_selected_items()
	for idx in idxs:
		dict["files"].append(get_item_metadata(idx))
	return dict

# =================================== 获取资源预览 ===================================
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
	pass
