# ========================================================
# 名称：SysMenuPlugin
# 类型：编辑器插件扩展类
# 简介：专用于编辑器主菜单插件的开发，提供基本函数
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-12 01:38:33
# 最后修改时间：2023年4月24日01:02:22
# ========================================================
#class_name SysMenuPlugin
extends "../GDEditor.gd"



# ================================================ 顶部菜单

# 返回 - 索引为idx的顶部菜单 - MenuButton类型
func top_menu(idx:int):
	top_menu_bar.get_child(idx)

# 添加自定义顶部菜单 -返回创建的PopupMenu控件
func add_sys_top_menu(title:String,items:PackedStringArray,item_click:Callable) -> PopupMenu:
	var menu = PopupMenu.new()
	menu.name = title
	for item in items:
		menu.add_item(item)
	menu.index_pressed.connect(func(index):
		item_click.call(menu.get_item_text(index))
	)
	top_menu_bar.add_child(menu)
	return menu


# 移除顶部菜单
# @param idx 要删除的顶部菜单在整个sys_top_menu_container中索引位置
#            一般请传入大于等于5的值，否则无效，不会删除原系统的菜单
func remove_sys_top_menu(idx = -1 ):
	pass
