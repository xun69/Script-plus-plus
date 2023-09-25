# ========================================================
# 名称：ItemGroups
# 类型：UI组件
# 简介：用于动态添加和显示分组列表
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-27 19:49:12
# 最后修改时间：2023-04-27 19:49:12
# ========================================================
@tool
extends ScrollContainer
# =================================== 信号 ===================================
signal title_renamed(new_title,gup_index)            # 分组标题重命名后发出
signal drop_item_added(files,gup_index)   # 通过拖放添加项后触发
signal item_clicked(path)            # 项被选中或单击
signal item_dbl_click(path)          # 项被双击时触发
signal items_deleted()       # 项被删除时触发
signal removed_group() # 点击删除分组按钮后触发

# =================================== 导出变量 ===================================
@export_category("ItemGroups")
## ItemGroup子组件
@export var group_tscn:PackedScene = preload("res://addons/resManager/parts/ItemGroup.tscn")
## 允许拖放的后缀类型
@export var filters:PackedStringArray = []

# =================================== 节点引用 ===================================
@onready var vbox = %VBox

# =================================== 方法 ===================================
# 添加分组并返回ItemGroup子组件的引用
func add_group(title:String):
	var gup = group_tscn.instantiate() # 创建ItemGroup实例
	vbox.add_child(gup)
	gup.filters = filters # 设定ItemGroup实例允许拖放的后缀类型
	# 信号链接
	gup.title_renamed.connect(func(new_title): # 标题重命名
		emit_signal("title_renamed",new_title,gup.get_index())
	)
	gup.drop_item_added.connect(func(files): # 通过拖放添加项
		emit_signal("drop_item_added",files,gup.get_index())
	)
	gup.item_clicked.connect(func(path):   # 项被选中或单击
		emit_signal("item_clicked",path)
	)
	gup.item_dbl_click.connect(func(path):  # 项被双击
		emit_signal("item_dbl_click",path)
	)
	gup.items_deleted.connect(func():  # 项被删除
		emit_signal("items_deleted")
	)
	gup.remove_group.connect(func(gup_index):  # 删除分组后
		vbox.remove_child(vbox.get_child(gup_index))
		emit_signal("removed_group")
	)
	gup.title = title
	return gup

# 获取相应group的引用
func get_group(idx):
	return vbox.get_child(idx) if idx < vbox.get_child_count() else null

# 返回group的数量
func get_groups_count():
	return vbox.get_child_count()

# 移除指定索引的分组
func remove_group(idx:int):
	if idx < vbox.get_child_count():
		vbox.get_child(idx).queue_free()
	pass

# 全部清除
func clear():
	for i in vbox.get_child_count():
		vbox.get_child(i).queue_free()
	pass
