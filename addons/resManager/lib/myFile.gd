# ======================================================================
# 名称：myFile
# 描述：关于文件操作的静态函数库 基于 Godot4.0 重写
# 类型：静态函数库
# 作者：巽星石
# Godot版本：v4.0.2.stable.official [7a0977ce2]
# 创建时间：2023年4月7日23:02:21
# 最后修改时间：2023年4月8日10:40:42
# ======================================================================

#class_name myFile

# ========================= 文件、文件夹基础操作 =========================


# 判断文件夹路径是否存在
static func is_dir_exists(dir_path:String) -> bool:
	var bol
	if DirAccess.dir_exists_absolute(dir_path):
		bol = true
	return bol

# 判断文件夹路径是否存在,如果不存在就创建
static func dir_exists_or_create(dir_path:String) -> void:
	# 如果路径不存在，就创建路径
	if !DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)

# 判断文件夹路径是否存在
static func is_file_exists(file_path:String) -> bool:
	var bol
	if FileAccess.file_exists(file_path):
		bol = true
	return bol

# 复制文件
static func copy(from:String,to:String) -> void:
	if FileAccess.file_exists(from):
		DirAccess.copy_absolute(from,to)

# 删除file_path指定的文件
static func kill_file(file_path:String) -> void:
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)

# 删除dir_path指定的路径处的文件夹
static func kill_dir(dir_path:String) -> void:
	if DirAccess.dir_exists_absolute(dir_path):
		# 删除所有子文件
		if DirAccess.get_files_at(dir_path).size() != 0:
			var sub_files = get_sub_files(dir_path)
			for file in sub_files:
				kill_file("%s/%s" % [dir_path,file])
		
		# 递归删除下一级文件夹
		if DirAccess.get_directories_at(dir_path).size() != 0:
			var sub_dirs = get_sub_dirs(dir_path)
			for dir in sub_dirs:
				kill_dir("%s/%s" % [dir_path,dir])
		
		DirAccess.remove_absolute(dir_path) # 最后删除自己
			

# ======================== 纯文本文件 - 读写 ======================== 

# 以纯文本形式，保存content到file_path指定的文件
static func saveString(file_path:String,content:String) -> void:
	# 判断是不是一个有效的文件名
	var fname = file_path.get_file()
	if fname.is_valid_filename():
		# 创建文件并存储内容
		var file = FileAccess.open(file_path,FileAccess.WRITE)
		file.store_string(content) # 整体存储
		file.close()

# 以纯文本形式，将new_content容追加到file_path指定的文件
static func appendString(file_path:String,new_content:String) -> void:
	# 判断是不是一个有效的文件名
	var fname = file_path.get_file()
	if fname.is_valid_filename():
		var old_content = ""
		if FileAccess.file_exists(file_path):
			old_content = FileAccess.get_file_as_string(file_path)
		var content = old_content + new_content
		# 创建文件并存储内容
		saveString(file_path,content)

# 以纯文本形式返回file_path参数所指定的文件中的内容
static func loadString(file_path:String) -> String:
	return FileAccess.get_file_as_string(file_path)

# ======================== 基于JSON存储的纯文本文件 - 读写 ======================== 

# 将对象或变量序列化为JSON字符串
static func var_to_JSON(ver,indent:String = ""):
	return JSON.stringify(ver,indent)
	

# 将JSON字符串反序列化为变量或对象
static func JSON_to_var(json_string:String = ""):
	return JSON.parse_string(json_string)


# 以纯文本形式，将对象或变量序列化为JSON字符串,并以带缩进的格式化形式保存到file_path所指定文件中
static func save_var_as_JSON_format_tab(file_path:String,ver) -> void:
	var content = var_to_JSON(ver,"\t")
	saveString(file_path,content)

# 以纯文本形式，将vars数组中所有对象或变量序列化为JSON字符串,并以带缩进的格式化形式保存到file_path所指定文件中
static func save_vars_as_JSON_format_tab(file_path:String,vars:Array) -> void:
	var JSONS_arr:PackedStringArray = []
	for ver in vars:
		JSONS_arr.append(var_to_JSON(ver,"\t"))
	saveString(file_path,"\n".join(JSONS_arr))


# 以纯文本形式，将对象或变量ver序列化为JSON字符串,并以单行的形式保存到file_path所指定文件中
static func save_var_as_JSON_inline(file_path:String,ver) -> void:
	var content = var_to_JSON(ver)
	appendString(file_path,content)
	
# 将多行以单行JSON字符串保存的数据，转化为字典
static func inline_JSONS_to_dict(inline_JSONS:String,ver) -> void:
	pass

# ======================== 基于数组和CSV存储的纯文本文件 - 读写 ======================== 

# 保存数组为CSV - 单个文件 - 单行CSV
static func saveCSV(path:String,content:PackedStringArray) -> void:
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_csv_line(content)




# ========================= 路径转化和资源管理器定位 =========================
# 将路径转化为全局路径
static func to_global_path(path:String):
	return ProjectSettings.globalize_path(path)

# 将路径转化为Windows可以识别的全局路径
func to_windows_path(path:String) -> String:
	path = to_global_path(path)
	path = path.replace("/","\\")
	return path


# ========================= shell_open =========================
# 用外部默认可识别此文件的程序打开文件
# 文件夹则默认由Windos资源管理器打开
static func shell_open(path:String):
	OS.shell_open(to_global_path(path))

# 用指定的应用程序打开文件
func shell_open_by_app(app_name:String,path:String):
	OS.execute("CMD.exe", ["/C", "%s %s" % [app_name,to_windows_path(path)]])

# 定位文件或文件夹路径并选中
func shell_open_and_select(path:String) ->void:
	OS.execute("CMD.exe", ["/C", "Explorer /select,%s" % to_windows_path(path)])

# 打开项目
# 必须指定project.godot文件
static func shell_open_rroject(project_godot_path:String) -> void:
	OS.execute(OS.get_executable_path(), [project_godot_path])

# ======================== 文件/文件夹列表获取 ======================== 
# 返回dir_path路径下，所有子文件夹名称列表
static func get_sub_dirs(dir_path:String) -> PackedStringArray:
	return DirAccess.get_directories_at(dir_path)

# 返回dir_path路径下，所有子文件名称列表
static func get_sub_files(dir_path:String) -> PackedStringArray:
	return DirAccess.get_files_at(dir_path)

# 返回dir_path路径下，所有后缀名为.file_filter的子文件名称列表
static func get_sub_filter_files(dir_path:String,file_filter:String) -> PackedStringArray:
	var sub_files_arr:PackedStringArray = get_sub_files(dir_path)
	var filter_files_arr:PackedStringArray = []
	for sub in sub_files_arr:
		if sub.ends_with(".%s" % file_filter):
			filter_files_arr.append(sub)
	return filter_files_arr
