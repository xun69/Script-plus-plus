# ========================================================
# 名称：ScriptPlugin
# 类型：类
# 简介：专职用于脚本编辑器插件开发的类
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-10 22:43:30
# 最后修改时间：2023年4月19日23:04:37
# ========================================================
@tool
extends "../GDEditor.gd"
#class_name ScriptPlugin

# =================================== 脚本编辑器 - 菜单栏 ===================================

## 将control控件添加到脚本编辑器菜单前面
func add_control_before_ScriptEditor_menus(control:Control) -> void:
	var p = ScriptEditor_topbar
	p.add_child(control)	
	p.move_child(control,0)

## 将control控件添加到脚本编辑器菜单后面
func add_control_behind_ScriptEditor_menus(control:Control) -> void:
	# 获取脚本编辑器菜单后面第一个Control控件
	var ctl = get_child_as_class(ScriptEditor_topbar,"Control")
	var p = ScriptEditor_topbar
	var idx = ctl.get_index()
	p.add_child(control)	
	p.move_child(control,idx)
	
## 将control控件添加到脚本编辑器左上角VBox（脚本列表）的后面
func add_control_to_ScriptEditor_LU_Vox(control:Control) -> void:
	ScriptEditor_LU_Vbox.add_child(control)

## 将control控件添加到脚本编辑器左下角VBox（方法列表）的后面
func add_control_to_ScriptEditor_LB_Vox(control:Control) -> void:
	ScriptEditor_LB_Vbox.add_child(control)

## 将control控件添加到脚本编辑器右侧VBox（脚本编辑框）的下面
func add_control_to_ScriptEditor_RB(control:Control) -> void:
	ScriptEditor_R_vbox.add_child(control)

## 将control控件添加到脚本编辑器右侧VBox（脚本编辑框）的上面
func add_control_to_ScriptEditor_RU(control:Control) -> void:
	ScriptEditor_R_vbox.add_child(control)
	ScriptEditor_R_vbox.move_child(control,0)

# =================================== 获取对象 ===================================

# 返回当前脚本的Script类型对象
func get_current_Script_Obj() -> Script:
	return face.get_script_editor().get_current_script()

# 返回ScriptEditor当前的控件
func get_current_control():
	var ctl = null
	var tab_ctr = ScriptEditor_TabContainer.get_current_tab_control()
	if tab_ctr.get_class() == "ScriptTextEditor":
		ctl = face.get_script_editor().get_current_editor().get_base_editor()
	elif tab_ctr.get_class() == "EditorHelp":
		ctl = tab_ctr.get_child(0)
	return ctl

func current_is_script() -> bool:
	return get_current_control() is CodeEdit

func current_is_help() -> bool:
	return get_current_control() is RichTextLabel

## 返回当前代码编辑器的CodeEdit控件。[br]
## 基于此，你可以使用CodeEdit相关的方法来控制当前代码编辑器的内容。
func get_current_Script_CodeEdit() -> CodeEdit:
	return get_current_control() if current_is_script() else null

func get_current_Help_RichTextLabel() -> RichTextLabel:
	return get_current_control() if current_is_help() else null

## 返回当前显示的内置文档的文本。[br]
## 注意：内置文档需要处于打开状态。否则返回""。
func get_current_Help_text() -> String:
	return get_current_Help_RichTextLabel().get_parsed_text() if current_is_help() else ""

# =================================== 脚本 - 添加内容 ===================================
# 在当前脚本编辑器插入字符串
func insert_string_at_caret(string:String) -> void:
	if current_is_script():
		get_current_Script_CodeEdit().insert_text_at_caret(string)

# 在脚本顶部添加 - 元信息注释
func add_top_meta_comment() -> void:
	var tmp = """# ========================================================
# 名称：
# 类型：
# 简介：
# 作者：
# Godot版本：[engine_version]
# 创建时间：[Now]
# 最后修改时间：[Now]
# ========================================================"""
	tmp = tmp.replace("[engine_version]",engine_version())
	tmp = tmp.replace("[Now]",Now())
	get_current_Script_CodeEdit().text = "%s\n%s" % [tmp,get_current_Script_CodeEdit().text]

# 在光标处插入 - 分割线注释
func insert_HR_comment(comment:String = "",str_or_char:String = "=",repeat_time:int = 35) -> void:
	repeat_time = clamp(repeat_time,0,45)
	if comment != "":
		var HR_harf = str_or_char.repeat(repeat_time)
		insert_string_at_caret("# %s %s %s" % [HR_harf,comment,HR_harf])
	else:
		insert_string_at_caret("# %s" % str_or_char.repeat(repeat_time * 2))

# =================================== 其他 ===================================

# 打开相应类型的内置文档
func goto_help(classType:String) -> void:
	face.get_script_editor().get_current_editor().emit_signal("go_to_help",classType)

# 打开新建脚本对话框
func open_script_create_dialog(base_name:String,base_path:String = "%s/new_script" % get_file_sys_dock_current_dir()):
	face.get_script_editor().open_script_create_dialog(base_name,base_path)

# 为当前项目创建script_templates目录
func create_script_tmp_dir_in_project():
	DirAccess.make_dir_absolute("res://script_templates/")
	update_file_sys_dock()

