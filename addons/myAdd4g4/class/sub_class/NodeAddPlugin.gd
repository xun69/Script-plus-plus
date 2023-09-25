# ========================================================
# 名称：NodeAddPlugin
# 类型：插件扩展类
# 简介：专用于节点添加类插件开发
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-20 22:42:28
# 最后修改时间：2023年4月22日17:27:18
# ========================================================

@tool
extends "SceneTreePlugin.gd"
#class_name NodeAddPlugin

# “创建节点”对话框
var AddNode_dialog

func _init():
	super._init()
	AddNode_dialog = get_child_as_class(Scene_dock,"CreateDialog")


# ---- 节点添加 ----
# 返回当前场景中选中的节点(选中多个时只返回第一个)
func get_selected_node() -> Node:
	var sels = face.get_selection().get_selected_nodes() 
	return sels[0] if sels.size() == 1 else null

# 返回当前正在编辑的场景的根节点
func get_edited_scene_root():
	return face.get_edited_scene_root()

# 判断当前场景是否为空场景(也就是没有添加任何节点)
func current_scene_is_empty() -> bool:
	return true if not get_edited_scene_root() else false

# 返回场景面板顶部“添加节点”按钮的引用
func open_AddNode_dialog():
	var addBtn:Button = get_child_by_indexPath(Scene_dock,[0,0])
	addBtn.emit_signal("pressed")

# 根据short_struct所指定的节点结构，创建新场景或为当前选中节点添加子节点
func add_nodes_by_short_struct(short_struct:String):
	if short_struct == "" or short_struct.strip_edges() == "":
		push_warning("结构字符串为空")
		return
	var nodes = create_nodes_by_short_struct(short_struct)
	if current_scene_is_empty():
		empty_scene_add_root(nodes)
	else:
		select_add_child(nodes)

# 通过简写的节点结构字符串创建节点，并返回
func create_nodes_by_short_struct(short_struct:String):
	if short_struct.find(">") != -1:
		var levels = short_struct.split(">",false)
		var root:Node = null
		var p_node:Node = null
		for i in levels.size():
			if i == 0: # 根节点
				root = ClassDB.instantiate(levels[i])
				root.name = levels[i]
				p_node = root
			else:
				if levels[i].find("+") > -1: # 有并列子子节点
					var bros = levels[i].split("+",false)
					for bro in bros:
						var node = ClassDB.instantiate(bro)
						node.name = bro
						p_node.add_child(node,true)
				else:
					var node = ClassDB.instantiate(levels[i])
					node.name = levels[i]
					p_node.add_child(node,true)
					p_node = node
		return root
	else: # 没有子级
		if ClassDB.class_exists(short_struct):
			var node = ClassDB.instantiate(short_struct)
			node.name = short_struct
			return node


# 为空场景添加根节点
func empty_scene_add_root(node:Node) -> void:
	var nodeType = node.get_class()
	if current_scene_is_empty():# 当前场景为空场景
		# 新建根节点
		open_AddNode_dialog() # 打开“添加Node”对话框
		# 搜索框
		var left_Vbox = get_child_by_indexPath(AddNode_dialog,[0, 1])
		var txt:LineEdit = get_child_by_indexPath(left_Vbox,[1, 0, 0])
		txt.text = nodeType # 修改搜索关键字
		txt.emit_signal("text_changed",nodeType) # 触发“文本改变”信号
		# "创建"按钮
		AddNode_dialog.emit_signal("confirmed")# 触发“创建”按钮pressed信号
#		await face.get_tree().create_timer(0.2).timeout
		
		var pros = node.get_property_list()
		for pro in pros:
			get_edited_scene_root().set(pro["name"],node.get(pro["name"]))
		add_childrens_to_root(get_edited_scene_root(),node)

		
		
		
		
		

# 根据指定类型为空场景添加根节点
func empty_scene_add_root_by_class(nodeType:String) -> void:	
	if current_scene_is_empty():# 当前场景为空场景
		# 新建根节点
		open_AddNode_dialog() # 打开“添加Node”对话框
		# 搜索框
		var left_Vbox = get_child_by_indexPath(AddNode_dialog,[0, 1])
		var txt:LineEdit = get_child_by_indexPath(left_Vbox,[1, 0, 0])
		txt.text = nodeType # 修改搜索关键字
		txt.emit_signal("text_changed",nodeType) # 触发“文本改变”信号
		
		# "创建"按钮
		AddNode_dialog.emit_signal("confirmed")# 触发“创建”按钮pressed信号
	

# 为当前场景选中节点添加对应类型的子节点
# @param nodeType 节点类型名称，字符串
func select_add_child_by_class(nodeType:String):
	var selected_node = get_selected_node()
	if selected_node: # 存在选中节点
		if ClassDB.class_exists(nodeType):
			# 添加子节点
			var node:Node = ClassDB.instantiate(nodeType) # 按照类型名称添加节点
			node.name = nodeType
			selected_node.add_child(node,true)
			node.owner = get_edited_scene_root() # 设置owner为场景根节点
			# 选中新添加的节点
			await face.get_tree().create_timer(0.02).timeout
			var tree:Tree = Scene_dock_Tree
			var old_sel:TreeItem = tree.get_selected()
			var count = old_sel.get_child_count()
			tree.set_selected(old_sel.get_child(count-1),0)

# 为当前场景选中节点添加子节点
# 这个方法相比select_add_child_by_class，可以更好的构造和配置子节点
# 甚至是添加带有结构的节点
func select_add_child(node:Node):
	var selected_node = get_selected_node()
	if selected_node: # 存在选中节点
		selected_node.add_child(node,true)
		node.owner = get_edited_scene_root() # 设置owner为场景根节点
		set_children_owner(node,node.owner)
		# 选中新添加的节点
		await face.get_tree().create_timer(0.02).timeout
		var tree:Tree = Scene_dock_Tree
		var old_sel:TreeItem = tree.get_selected()
		var count = old_sel.get_child_count()
		tree.set_selected(old_sel.get_child(count-1),0)

# 设置node的所有子孙节点的owner
func set_children_owner(node:Node,owner:Node) -> void:
	var childs = node.get_children()
	for child in childs:
		child.owner = owner
		set_children_owner(child,owner)

# 设置node的所有子孙节点的owner
func add_childrens_to_root(p_node:Node,node:Node) -> void:
	for child in node.get_children():
		var chd = child.duplicate()
		p_node.add_child(chd,true)
		chd.owner = get_edited_scene_root()
		add_childrens_to_root(chd,child)
