# ========================================================
# 名称：ScriptDoc
# 类型：静态函数库
# 简介：专用于生成脚本的文档，包括HTML、MarkDown等
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-09 19:45:48
# 最后修改时间：2023年4月9日21:37:42
# ========================================================
# class_name ScriptDoc

# =================================== 方法 ===================================
# 生成并返回脚本对象sc的Markdown文档字符串
static func get_Script_MDdoc_str(sc:Script) -> String:
	# === 依赖 === 
	var ScriptInfo = preload("res://addons/Script++/lib/ScriptInfo.gd")
	var MDCreator = preload("res://addons/Script++/lib/MDCreator.gd")

	# === 文档模板 === 
	var md_tmp_path = "res://addons/Script++/lib/MD_tmps/ScriptDoc.md"
	
	# 基本信息
	var md_tmp = FileAccess.get_file_as_string(md_tmp_path)
	md_tmp = md_tmp.replace("[ScriptName]",ScriptInfo.file_name(sc))
	md_tmp = md_tmp.replace("[engine_version] ",engine_version())
	md_tmp = md_tmp.replace("[date_time]",Now())
	md_tmp = md_tmp.replace("[is_tool]",str(ScriptInfo.is_tool(sc)))
	md_tmp = md_tmp.replace("[extend]",ScriptInfo.get_extends_type(sc))
	md_tmp = md_tmp.replace("[class_name]",ScriptInfo.get_class_name(sc))
	md_tmp = md_tmp.replace("[project_name]",project_name())
	md_tmp = md_tmp.replace("[res_file_path]",ScriptInfo.file_path(sc))
	md_tmp = md_tmp.replace("[abs_file_path]",ScriptInfo.global_path(sc))
	md_tmp = md_tmp.replace("[author]","")
	# 信号
	var signal_lists = ScriptInfo.get_signal_lists(sc)
	var signal_table = MDCreator.TH(["信号","描述"])
	for sig in signal_lists:
		signal_table += MDCreator.TR([sig,""])
	md_tmp = md_tmp.replace("[signals_lists]",signal_table)
	# 枚举
	var enum_str = ""
	var enum_lists = ScriptInfo.get_enum_lists(sc)
	for enm in enum_lists:
		for key in enm:
			enum_str += "### %s\n" % key
			for k in enm[key]:
				enum_str += "- %s = %s\n" % [k,enm[key][k]]
	md_tmp = md_tmp.replace("[enums_list]",enum_str)
	# 常量
	var const_lists = ScriptInfo.get_const_lists(sc)
	var const_table = MDCreator.TH(["常量","描述"])
	for cst in const_lists:
		const_table += MDCreator.TR([cst,""])
	md_tmp = md_tmp.replace("[consts_list]",const_table)
	# 变量
	var vars_lists = ScriptInfo.get_property_lists(sc)
	var vars_table = MDCreator.TH(["变量","类型","描述"])
	for ver in vars_lists:
		vars_table += MDCreator.TR([ver["name"],ver["type"],""])
	md_tmp = md_tmp.replace("[vars_list]",vars_table)
	# 方法
	var methods_lists = ScriptInfo.get_method_lists(sc)
	var methods_lists2:PackedStringArray = []
	for method in methods_lists:
		methods_lists2.append("### %s\n这是是描述。" % method) 
	var methods_str = "\n".join(methods_lists2)
	md_tmp = md_tmp.replace("[method_lists]",methods_str)
	# 源代码
	md_tmp = md_tmp.replace("[source_code]",sc.source_code)
	return md_tmp

# 生成并返回脚本对象sc的HTML打印字符串
static func get_Script_HTMLPrint_str(sc:Script) -> String:
	# === 依赖 === 
	var ScriptInfo = preload("res://addons/Script++/lib/ScriptInfo.gd")
	var MDCreator = preload("res://addons/Script++/lib/MDCreator.gd")

	# === 文档模板 === 
	var html_tmp_path = "res://addons/Script++/lib/HTML_tmps/ScriptPrint.html"
	
	# 基本信息
	var html_tmp = FileAccess.get_file_as_string(html_tmp_path)
	html_tmp = html_tmp.replace("[ScriptName]",ScriptInfo.file_name(sc))
	html_tmp = html_tmp.replace("[doc_export_time]",Now())
	html_tmp = html_tmp.replace("[file_name]",ScriptInfo.file_name(sc).replace(".gd",""))
	html_tmp = html_tmp.replace("[source_code]",sc.source_code)
	return html_tmp



# 按指定的行数划分代码，返回数组
func code_split(code:String,lines:int = 15) -> PackedStringArray:
	var _lines:PackedStringArray = []
	var code_lines = code.split("\n")
	var lines_str = ""
	for i in code_lines.size():
		if posmod(i+1,lines) != 0:
			lines_str += code_lines[i] + "\n"
		elif i == code_lines.size():
			lines_str += code_lines[i] + "\n"
			_lines.append(lines_str)
			lines_str = ""
		else:
			lines_str += code_lines[i] + "\n"
			_lines.append(lines_str)
			lines_str = ""
	return _lines


# =================================== 额外需要 ===================================
# 返回当前日期时间字符串
# 形如： YYYY-MM-DD HH:MM:SS
static func Now() -> String:
	return Time.get_datetime_string_from_system(false,true).replace("T"," ")

# 返回引擎当前版本信息
static func engine_version() ->String:
	return Engine.get_version_info()["string"]

# 当前项目名称
static func project_name():
	return ProjectSettings.get_setting("application/config/name") 
