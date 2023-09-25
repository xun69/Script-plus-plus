# ========================================================
# 名称：EditorDebugger For Godot 4
# 类型：面板
# 简介：自己重新设计，用于方便Godot 4.0编辑器插件编写
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-21 00:09:59
# 最后修改时间：2023-04-21 00:09:59
# ========================================================

@tool
extends TabContainer


@onready var tree = %Tree
@onready var depth_spin = %depthSpin
@onready var name_txt_1 = %nameTxt1
@onready var name_txt_2 = %nameTxt2
@onready var indexs_txt = %indexsTxt

const BASE_DIR = "res://addons/editordebugger4g4/"
const TXTS_DIR = "res://addons/editordebugger4g4/txts/"


var plug:EditorPlugin
var face:EditorInterface
var base_control:Panel
var face_root:Window
var show_rect:ColorRect
var controls_class:PackedStringArray

var last_fater:TreeItem

var err_icon:Texture2D = get_class_icon("EditorExport")



func _ready():
	plug = EditorPlugin.new()
	face = plug.get_editor_interface()
	base_control = face.get_base_control()
	face_root = face.get_tree().root
	

	load_main_struct_nodes(tree)
	
	# 添加颜色矩形 - 指示当前节点的位置
	show_rect = ColorRect.new()
	show_rect.color = Color.BEIGE # 浅黄色
	show_rect.color.a = 0.4
	show_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	show_rect.hide()
	face_root.add_child(show_rect)



func _exit_tree():
	face_root.remove_child(show_rect)

# 仅加载编辑器结构的全部节点
# 也就是root开始的结构
func load_all_struct_nodes(tree:Tree):
	tree.clear()
	tree.set_column_title(0,"节点")
	tree.set_column_expand(0,true)
	tree.set_column_title(1,"路径")
	tree.set_column_custom_minimum_width(1,2)
	# 加载节点树
	var itm:TreeItem = tree.create_item()
	itm.set_text(0,"%s[%s]" % [face_root.get_class(),face_root.name])
	load_nodes(tree,face_root,itm)


# 仅加载编辑器结构主线的节点
# 也就是base_control和其VBox节点开始的结构
func load_main_struct_nodes(tree:Tree):
	tree.clear()
	tree.set_column_title(0,"节点")
	tree.set_column_title(1,"路径")
	# 添加base_control
	var root:TreeItem = tree.create_item()
	root.set_text(0,"%s[%s]" % [base_control.get_class(),base_control.name])
	root.set_icon(0,get_class_icon(base_control.get_class()))
	root.set_metadata(0,base_control.get_path())
	# 添加VBox
	var vbox = base_control.get_child(0)
	var itm:TreeItem = tree.create_item(root)
	itm.set_text(0,"%s[%s]" % [vbox.get_class(),vbox.name])
	itm.set_icon(0,get_class_icon(vbox.get_class()))
	itm.set_metadata(0,vbox.get_path())
	load_nodes(tree,vbox,itm)


# 加载编辑器节点结构到Tree控件
func load_nodes(tree:Tree,p_node:Node,p_itm:TreeItem):
	var childs = p_node.get_children()
	for chd in childs:
		var itm:TreeItem = tree.create_item(p_itm)
		itm.set_text(0,"%s[%s]" % [chd.get_class(),chd.name])
		var icon
		if ClassDB.can_instantiate(chd.get_class()):
			icon = get_class_icon(chd.get_class())
		else:
			icon = get_class_icon("Node")
			itm.set_custom_color(0,Color.DARK_RED)
		itm.set_icon(0,icon)
		itm.set_metadata(0,chd.get_path())
		load_nodes(tree,chd,itm)

# 快捷键F10 - 显示鼠标处的对象区域
func _unhandled_key_input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F10:
			var tree_root:TreeItem = tree.get_root()
			var itms = find_editor_node_as_pos(tree_root)
			# 将面积重新构成数组
			var area_arr = []
			for itm in itms:
				var _path = itm.get_metadata(0) # 获取路径
				var editor_node = face_root.get_node(_path)
				
				var editor_node_rect:Rect2 = editor_node.get_global_rect()
				area_arr.append(editor_node_rect.get_area())
				
			var min_area = area_arr.min() # 最小面积
			for itm in itms:
				var _path = itm.get_metadata(0) # 获取路径
				var editor_node = face_root.get_node(_path)
				
				var editor_node_rect:Rect2 = editor_node.get_global_rect()
				if editor_node_rect.get_area() == min_area:
					itm.select(0)
					tree.scroll_to_item(itm)

func find_editor_node_as_pos(p_itm:TreeItem) -> Array:
	var mouse_pos = get_global_mouse_position()
	var children = p_itm.get_children()
	var itm_arr = []
	for child in children:
		var _path = child.get_metadata(0) # 获取路径
		var editor_node = face_root.get_node(_path)
		
		if editor_node.has_method("get_global_rect"):
			var editor_node_rect:Rect2 = editor_node.get_global_rect()
			
			if editor_node_rect.has_point(mouse_pos):
				itm_arr.append(child)
				
		itm_arr += find_editor_node_as_pos(child)
	return itm_arr


# 节点选中或单击
func _on_tree_item_selected():
	var sel:TreeItem = tree.get_selected()
	var path = sel.get_metadata(0)
	var editor_node = face_root.get_node(path)
	
	if editor_node.has_method("get_global_rect") and %ShowRectBtn.button_pressed:
		var editor_node_rect = editor_node.get_global_rect()
		show_rect.global_position = editor_node_rect.position
		show_rect.size = editor_node_rect.size
		show_rect.show()
	else:
		show_rect.hide()
		show_rect.global_position = Vector2.ZERO
		show_rect.size = Vector2.ZERO
	
	show_relative_indexs_msg(editor_node,int(depth_spin.value))
	heighlight_depth_fater_treeitem(sel,int(depth_spin.value))

# 生成和显示用于提示某个节点相对于其几层父节点的索引路径信息
func show_relative_indexs_msg(node:Node,faterDepth:int = 1) -> void:
	var index_arr_str = str(relative_idnex_array(node,faterDepth))
	var father:Node = depth_fater(node,faterDepth)
	name_txt_1.text = "%s[%s]" % [node.get_class(),node.name]
	name_txt_2.text = "%s[%s]" % [father.get_class(),father.name]
	indexs_txt.text = index_arr_str

# 突出显示itm的深度父节点
func heighlight_depth_fater_treeitem(itm:TreeItem,faterDepth:int = 1) -> void:
	var father:TreeItem
	for i in range(faterDepth):
		father = itm.get_parent()
		itm = father
	if last_fater and last_fater != father:
		last_fater.clear_custom_bg_color(0)
	last_fater = father
	father.set_custom_bg_color(0,Color(Color.DEEP_SKY_BLUE,0.4))
	
## 返回节点node相对于其faterDepth层父节点或祖先节点的索引路径
func relative_idnex_array(node:Node,faterDepth:int = 1)->PackedInt32Array:
	var arr:PackedInt32Array = []
	for i in range(faterDepth):
		arr.insert(0,node.get_index())
		node = node.get_parent()
	return arr

## 返回节点node向上faterDepth层的父节点或祖先节点
func depth_fater(node:Node,faterDepth:int = 1) -> Node:
	var father
	for i in range(faterDepth):
		father = node.get_parent()
		node = father
	return father


func _on_show_indexs_btn_pressed():
	var sel:TreeItem = tree.get_selected()
	var path = sel.get_metadata(0)
	var editor_node = face_root.get_node(path)
	
	show_relative_indexs_msg(editor_node,int(depth_spin.value))
	pass

# =================================== 辅助函数 ===================================
# 获取classType类型的图标
func get_class_icon(classType:String) -> Texture2D:
	return base_control.get_theme_icon(classType, "EditorIcons")


func _on_show_main_btn_toggled(button_pressed):
	if button_pressed:
		load_main_struct_nodes(tree)
	else:
		load_all_struct_nodes(tree)
	pass


func _on_show_rect_btn_toggled(button_pressed):
	show_rect.visible = button_pressed
	pass
