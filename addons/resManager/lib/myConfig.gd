# ======================================================================
# 名称：myConfig
# 描述：ConfigFile相关操作函数库 基于 Godot 4.0 适配的版本
# 核心：通过将ConfigFile文件转化为字典，简化配置项的设计和使用
# 类型：静态函数库
# 作者：巽星石
# Godot版本：v4.0.2.stable.official [7a0977ce2]
# 创建时间：2023年4月8日10:46:48
# 最后修改时间：2023年4月8日10:46:48
# ======================================================================

#class_name myConfig

# 将纯文本的ConfigFile文件加载为一个字典
static func load_config_as_dic(file_path:String) -> Dictionary:
	var dic
	var dir = DirAccess
	var file = FileAccess
	if !file.file_exists(file_path):
		push_warning("%s 不存在，请输入有效的路径" % file_path)
	else:
		var cfg = ConfigFile.new()
		var err = cfg.load(file_path)
		if err != OK:
			push_warning("%s并不是有效的ConfigFile文件" % file_path)
		else:
			dic = {}
			# 获取section集合
			var secs = cfg.get_sections()
			for sec in secs:
				dic[sec] = {} # 添加每个section为一个字典
				var keys = cfg.get_section_keys(sec)
				for key in keys:
					dic[sec][key] = cfg.get_value(sec,key) # 添加每个键值对为section下的键值对
	return dic

# 将字典保存为一个ConfigFile文件
# 字典形式如：
#var cfg_dic = {
#	screen_size = {
#		screen_mode = "最大化", # 屏幕模式
#	}
#}
# 其中第一层为Section，第二层为 key:value 对
static func save_dic_as_config(file_path:String,dic:Dictionary) -> void:
	var cfg = ConfigFile.new()
	for sec in dic: 
		for key in dic[sec]:
			cfg.set_value(sec,key,dic[sec][key])
	cfg.save(file_path)
	pass

# 创建插件的 plugin.cfg 配置文件
static func create_plugin_cfg(plugin_name:String,plugin_author:String,desc:String = "",version = "",script_file_name = "plugin.gd"):
	var plugin_dir = "res://addons/%s/" % plugin_name
	var save_file_path = "%s%s" % [plugin_dir,"plugin.cfg"]
	
	# 构建字典
	var cfg_dic = {
		plugin = {
			name = plugin_name,   # 插件名称
			description = desc,   # 插件的简介或描述
			author = plugin_author, # 插件的作者
			version = version,    # 插件版本号
			script = script_file_name # 插件主脚本文件的名称
		}
	}
	# 保存为 plugin.cfg
	# 确保插件路径存在
	if !DirAccess.dir_exists_absolute(plugin_dir):
		DirAccess.make_dir_recursive_absolute(plugin_dir)
	save_dic_as_config(save_file_path,cfg_dic)
