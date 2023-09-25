# ========================================================
# 名称：WindowPlugin
# 类型：编辑器插件扩展类
# 简介：专职于创建和显示自定义窗体和对话框的类（仅用于插件发）
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023年4月8日12:03:06
# 最后修改时间:2023年4月19日23:06:48
# ========================================================

@tool
extends "../GDEditor.gd"
#class_name WindowPlugin

# ============================== 基础的创建和关闭窗体 

# 创建窗体
func create_window(title:String = "定义窗体", width = 500,height = 500) -> Window:
	# 创建Window实例
	var win = Window.new()
	win.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	win.title = title
	win.size = Vector2(width,height)
	
	
	# 处理关闭请求
	win.close_requested.connect(func ():
		win.queue_free()
	) 
	return win

# 创建并返回一个FileDialog实例
# 默认参数，返回一个保存文件对话框
func create_file_dialog(
		title:String = "保存",
		width:int = 800,
		height:int = 800,
		dlg_mode:int = FileDialog.FILE_MODE_SAVE_FILE,
		access:int= FileDialog.ACCESS_RESOURCES,
		base_dir:String = "res://",
		filters:PackedStringArray = [],
		show_hidden:bool = false,
	) -> FileDialog:
	var file_dlg = FileDialog.new()
	file_dlg.file_mode = dlg_mode
	file_dlg.access = access
	file_dlg.root_subfolder = base_dir
	file_dlg.filters = filters
	file_dlg.show_hidden_files = show_hidden
	
	file_dlg.mode = Window.MODE_WINDOWED
	file_dlg.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	
	file_dlg.title = title
	file_dlg.size = Vector2(width,height)
	return file_dlg

# ============================== 具体的窗体

# 显示纯文本内容的窗体
func show_txt_window(title:String = "文本",content:String = "",width = 500,height = 500) -> Window:
	# 创建Window实例
	var win = create_window(title,width,height)

	
	# 创建TextEdit
	var txt = TextEdit.new()
	txt.text = content
	win.add_child(txt)
	txt.anchors_preset = Control.PRESET_FULL_RECT
	
	# 显示
	base_control.add_child(win)
	win.show()
	
	
	# 返回Window实例自身
	return win

# 显示简单的提示信息
func show_msg(call_back:Callable,msg:String,title:String = "提示",width = 500,height = 200) -> AcceptDialog:
	var dlg = AcceptDialog.new()
	dlg.title = title
	dlg.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	dlg.title = title
	dlg.size = Vector2(width,height)
	dlg.dialog_text = msg
	
	dlg.close_requested.connect(func ():
		dlg.queue_free()
	)
	
	dlg.confirmed.connect(func():
		call_back.call()
	)
	
	
	# 显示
	base_control.add_child(dlg)
	dlg.show()
	
	return dlg

# 通过场景文件，显示窗体
func show_window_from_tscn(win_tscn:PackedScene):
	var win = win_tscn.instantiate()
	# 显示
	base_control.add_child(win)
	win.show()
	
	return win


# 显示简单的输入对话框
# 回调函数接收一个参数返回输入的文本
func show_input_dialog(call_back:Callable,title:String = "输入",msg:String = "请输入：",placeholder:String = "",width = 500,height = 200) -> Window:
	# 创建Window实例
	var win = create_window(title,width,height)
	win.unresizable = true
	win.exclusive = true
	win.transient = true
	
	win.close_requested.connect(func ():
		win.queue_free()
	)
	
	var vbox = VBoxContainer.new()
	
	win.add_child(vbox)
	vbox.anchors_preset = Control.PRESET_FULL_RECT
#	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	
	var lab = Label.new()
	lab.text = msg
	lab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# 创建TextEdit
	var txt = LineEdit.new()
	txt.placeholder_text = placeholder
	txt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	vbox.add_child(lab)
	vbox.add_child(txt)
	
	var center = CenterContainer.new()
	var hbox = HBoxContainer.new()
	center.add_child(hbox)
	
	vbox.add_child(center)
	
	var okBtn = Button.new()
	okBtn.text = "确定"
	okBtn.unique_name_in_owner = true
	okBtn.pressed.connect(func():
		win.emit_signal("close_requested")
		call_back.call(txt.text)
	)
	hbox.add_child(okBtn)
	
	
	# 显示
	base_control.add_child(win)
	win.show()
	
	return win

# ============================== 具体的文件对话框
# 显示保存文件对话框
func show_save_dialog(
		title:String = "保存文件",
		base_dir:String = "res://",
		filters:PackedStringArray = [],
		show_hidden:bool = false
	) -> FileDialog:
	var save_dlg = create_file_dialog(title)
	save_dlg.root_subfolder = base_dir
	save_dlg.filters = filters
	save_dlg.show_hidden_files = show_hidden
	
	# 显示
	base_control.add_child(save_dlg)
	save_dlg.show()
	return save_dlg

# 显示打开文件对话框
func show_open_single_file_dialog(
		title:String = "打开文件",
		base_dir:String = "res://",
		filters:PackedStringArray = [],
		show_hidden:bool = false
	) -> FileDialog:
	var open_dlg = create_file_dialog(title)
	open_dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	open_dlg.root_subfolder = base_dir
	open_dlg.filters = filters
	open_dlg.show_hidden_files = show_hidden
	
	
	# 显示
	base_control.add_child(open_dlg)
	open_dlg.show()
	return open_dlg

