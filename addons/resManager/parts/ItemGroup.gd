# ========================================================
# 名称：ItemGroup
# 类型：UI组件
# 简介：带有一个标题和ItemList的分组
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-27 20:00:42
# 最后修改时间：2023-04-27 20:00:42
# ========================================================
@tool
extends VBoxContainer
# =================================== 信号 ===================================
signal title_renamed(new_title) # 标题重命名后发出
signal drop_item_added(files)  # 通过拖放添加项后触发
signal item_clicked(path)    # 项被点击
signal item_dbl_click(path)  # 项被双击时触发
signal items_deleted()       # 项被删除时触发
signal remove_group(gup_idx) # 点击删除分组按钮时触发

# =================================== 导出变量 ===================================
@export_category("ItemGroup")
@export var title = "": # 分组标题
	set(val):
		title = val
		if has_ready:
			title_lab.text = val
	get:
		if has_ready:
			return title_lab.text

# 分组展开图标
@export var down_icon:CompressedTexture2D = preload("res://addons/resManager/icons/down.png"):
	set(val):
		down_icon = val
		if has_ready:
			toggle_btn.icon = val

# 分组折叠后图标
@export var right_icon:CompressedTexture2D = preload("res://addons/resManager/icons/right.png")

## 允许ItemList拖放的后缀类型
@export var filters:PackedStringArray = []:
	set(val):
		filters = val
		if has_ready:
			item_list.filters = val

# =================================== 节点引用 ===================================
@onready var item_list:ItemList = %ItemList
@onready var title_lab = %titleLab
@onready var toggle_btn = %toggleBtn
@onready var rename_txt = %renameTxt
@onready var remove_btn = %removeBtn

# =================================== 依赖 ===================================
var GDEditor = preload("res://addons/resManager/class/GDEditor.gd").new()

# 是否已经_ready
var has_ready = false


func _ready():
	remove_btn.icon = GDEditor.get_icon("Remove")
	remove_btn.hide()
	toggle_btn.icon = down_icon
	has_ready = true

# =================================== 方法 ===================================
# 添加子节点
func add_item(title:String,icon:Texture2D):
	item_list.add_item(title,icon)
	
# 添加子节点
func remove_item(idx:int):
	item_list.remove_item(idx)

# 添加子节点
func get_selected_items():
	item_list.get_selected_items()

# 清空
func clear():
	item_list.clear()

# 返回项的数目
func get_item_count():
	return item_list.item_count
	
# 返回项的数目
func get_item_text(idx:int):
	return item_list.get_item_text(idx)

# 返回项的元数据
func get_item_metadata(idx:int):
	return item_list.get_item_metadata(idx)

# 返回项的元数据
func set_item_metadata(idx:int, metadata:Variant):
	item_list.set_item_metadata(idx,metadata)

# 进入标题编辑模式
func edit_title():
	rename_txt.text = title_lab.text
	title_lab.hide()
	rename_txt.show()

# 退出标题编辑模式
func quit_title_edit():
	title_lab.text = rename_txt.text
	rename_txt.hide()
	title_lab.show()
	emit_signal("title_renamed",rename_txt.text)

# =================================== 信号处理 ===================================
# 展开或隐藏分组
func _on_toggle_btn_pressed():
	item_list.visible = not item_list.visible
	toggle_btn.icon = down_icon if item_list.visible else right_icon 

# 分组名称被双击 -> 进入标题编辑模式
func _on_title_lab_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.double_click and event.is_pressed():
				edit_title() 

# 重命名标题后 - 按回车 -> 退出标题编辑模式
func _on_rename_txt_text_submitted(new_text):
	if new_text != "":
		quit_title_edit()

# 通过拖放添加项后
func _on_item_list_drop_item_added(files):
	emit_signal("drop_item_added",[files])


# 列表项 - 单击
func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	emit_signal("item_clicked",item_list.get_item_metadata(index))

	
# 列表项 - 双击
func _on_item_list_item_activated(index):
	emit_signal("item_dbl_click",item_list.get_item_metadata(index))


# 列表项 - delete键
func _on_item_list_gui_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_DELETE:
			var sels = item_list.get_selected_items()
			for idx in sels:
				item_list.remove_item(idx)
			get_tree().root.set_input_as_handled()
			emit_signal("items_deleted")

# 删除分组按钮 - 点击
func _on_remove_btn_pressed():
	emit_signal("remove_group",get_index())


# 标题区 - 鼠标移入
func _on_title_lab_mouse_entered():
	remove_btn.show()

# 标题区 - 鼠标移出
func _on_item_list_mouse_entered():
	remove_btn.hide()
