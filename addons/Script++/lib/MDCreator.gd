# ======================================================================
# 名称：MDCreator Godot 4.0 适配版
# 描述：MarkDown快速生成
# 说明：本函数库基于Typora编辑器所支持的语法进行创建
# 类型：静态函数库
# 作者：@巽星石
# Godot版本：v4.0.2.stable.official [7a0977ce2]
# 创建时间：2022年9月24日12:34:33
# 最后修改时间：2023年4月8日12:18:59
# ======================================================================

#class_name MDCreator

# H1-H6
static func H(level:int,title:String) -> String:
	level = clamp(level,1,6)
	var h_str = "#".repeat(level) + " " + title + "\n"
	return h_str

# 普通段落
static func P(content:String) -> String:
	return "\n" + content + "\n"
	
# quote - 引用
static func quote(content:String) -> String:
	var return_str = ""
	if "\n" in content: # 如果传入的内容为多行文本
		var quts = content.split("\n",false)
		return_str = "> %s\n".repeat(quts.size())
		return_str = return_str % quts as Array
	else:
		return_str = "> %s\n" % content
	return return_str

# 代码块
static func Code_Block(code:String,languege:String = "") -> String:
	return "```%s\n%s```\n" % [languege,code]
	
# 行内代码
static func Code_Inline(code:String) -> String:
	return "`%s`" % [code]
	
# OL - 有序列表
static func OL(str_list:PackedStringArray) -> String:
	var return_str =""
	for i in str_list.size():
		return_str += "%s. %s\n" % [str(i),str_list[i]]
	return  return_str

# UL - 无序列表
static func UL(str_list:PackedStringArray) -> String:
	var return_str =""
	for mstr in str_list:
		return_str += "- %s\n" % mstr
	return  return_str

# HR - 水平分隔线
static func HR() -> String:
	return "-".repeat(6) + "\n"
	
# TOC - 内容目录
static func TOC() -> String:
	return "[TOC]\n"

# 超链接
static func link(url:String,title:String="") -> String:
	var return_str =""
	if title == "":
		return_str = url
	else:
		return_str = "[%s](%s)\n" % [title,url]	
	return return_str

# 图片
static func img(src:String,title:String="") -> String:
	return "![%s](%s)\n" % [title,src]
	
# 表格 - 表头
static func TH(fields:PackedStringArray) -> String:
	var th ="| " + " | ".join(fields) + " |\n"
	th += "| " + "--- |".repeat(fields.size()) + "\n"
	return th
	
# 表格 - 行
static func TR(vals:PackedStringArray) -> String:
	var tr = "| " + " | ".join(vals) + " |\n"
	return tr

