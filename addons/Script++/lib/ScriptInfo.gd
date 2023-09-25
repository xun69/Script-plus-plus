# ======================================================================
# 名称：ScriptInfo 基于4.0完全重写版
# 描述：解析GDScript脚本，获取相关的信息
# 类型：静态函数库
# 作者：巽星石
# Godot版本：v4.0.2.stable.official [7a0977ce2]
# 创建时间：2023年4月8日12:32:34
# 最后修改时间：2023年4月9日18:56:17
# ======================================================================
# class_name ScriptInfo

# =================================== 额外提供 ===================================
# 获取script_path指定脚本所对应的Script对象
static func get_Script_obj_from_path(script_path:String) -> Script:
	var sc
	if FileAccess.file_exists(script_path):
		sc = load(script_path).new().get_script()
	return  sc

# =================================== 获取脚本的基本信息 ===================================

# 脚本路径(局部)
static func file_path(sc:Script) -> String:
	return sc.resource_path             

# 脚本文件名
static func file_name(sc:Script) -> String:
	return sc.resource_path.get_file() 

# 脚本路径(全局)
static func global_path(sc:Script) -> String:
	return ProjectSettings.globalize_path(sc.resource_path)

static func is_tool(sc:Script) -> bool: # 是否是工具脚本
	return sc.is_tool()

# 判断当前脚本是否是自定义类 - 也就是有没有定义class_name
static func is_a_class(sc:Script) -> bool: 
	var has_class_name = false
	var source_code = sc.source_code 
	var regex = RegEx.new()
	regex.compile("class_name .*")
	var result = regex.search(source_code)
	if result:
		has_class_name = true
	return has_class_name

# 返回class_name定义的类名
static func get_class_name(sc:Script) -> String:
	var c_name = ""
	var source_code = sc.source_code
	var regex = RegEx.new()
	regex.compile("class_name (.*)")
	var result = regex.search(source_code)
	if result:
		c_name = result.get_string(1)
	return c_name

# 继承的类型 - 基类
static func get_extends_type(sc:Script):
	return sc.get_instance_base_type()


# =================================== 获取Script对象成员列表 ===================================
# 获取Script对象的信号列表
static func get_signal_lists(sc:Script) -> PackedStringArray:
	var signal_arr:PackedStringArray = []
	var list = sc.get_script_signal_list()
	for sig in list:
		var args:PackedStringArray = []
		for arg in sig["args"]:
			args.append(arg["name"])
		signal_arr.append("%s(%s)" % [sig["name"],",".join(args)])
	return signal_arr

# 获取Script对象的枚举列表
static func get_enum_lists(sc:Script) -> Array[Dictionary]:
	var enums_arr:Array[Dictionary] = []
	var map = sc.get_script_constant_map()
	var keys = map.keys()
	for i in keys.size():
		if map[keys[i]] is Dictionary:
			enums_arr.append({keys[i]:map[keys[i]]})
	return enums_arr

# 获取Script对象的常数列表
static func get_const_lists(sc:Script) -> Array[Dictionary]:
	var consts_arr:Array[Dictionary] = []
	var map = sc.get_script_constant_map()
	var keys = map.keys()
	for i in keys.size():
		if not map[keys[i]] is Dictionary:
			consts_arr.append({keys[i]:map[keys[i]]})
	return consts_arr


# 获取Script对象的变量列表
static func get_property_lists(sc:Script) -> Array[Dictionary]:
	var prop_arr:Array[Dictionary] = []
	var list = sc.get_script_property_list()
	for prop in list:
		var dict = {}
		dict["name"] = prop["name"]
		if prop["type"] != 24: # 不是object类型
			dict["type"] = get_type_name(prop["type"])
		else:
			dict["type"] = prop["class_name"]
		prop_arr.append(dict)
	return prop_arr

# 返回一个Script对象的方法字符串列表
static func get_method_lists(sc:Script) -> PackedStringArray:
	var list = sc.get_script_method_list()
	var str_list:PackedStringArray = []
	for mtod in list:
		var aa = "%s(%s) -> %s" % [mtod["name"],get_arg_str(mtod["args"]),get_return_str(mtod["return"])]
		str_list.append(aa)
	return str_list

# +++++++++++++++++ 以下两个函数仅用于get_method_lists()方法调用 +++++++++++++++++
# 返回函数参数列表字符串
static func get_arg_str(args_arr:Array) -> String:
	var str_list:PackedStringArray = []
	if args_arr.size() == 0:
		return ""
	else:
		for arg in args_arr:
			var aa = "%s:%s" % [arg["name"],get_type_name(arg["type"])]
			str_list.append(aa)
		return ",".join(str_list)

# 返回函数return的类型字符串
static func get_return_str(return_dic:Dictionary) -> String:
	var rt_str = "void"
	if return_dic["type"] != 0:
		rt_str = get_type_name(return_dic["type"])
	return rt_str
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# 根据类型返回类型名称
static func get_type_name(type:int) ->String:
	var name_str = ""
	match type:
		TYPE_NIL:
			name_str = "null"
		TYPE_BOOL:
			name_str = "bool"
		TYPE_INT:
			name_str = "int"
		TYPE_FLOAT:
			name_str = "float"
		TYPE_STRING:
			name_str = "String"
		TYPE_VECTOR2:
			name_str = "Vector2"
		TYPE_VECTOR2I:
			name_str = "Vector2i"
		TYPE_RECT2:
			name_str = "Rect2"
		TYPE_RECT2I:
			name_str = "Rect2i"
		TYPE_VECTOR3:
			name_str = "Vector3"
		TYPE_VECTOR3I:
			name_str = "Vector3i"
		TYPE_TRANSFORM2D:
			name_str = "Transform2D"
		TYPE_VECTOR4:
			name_str = "Vector4"
		TYPE_VECTOR4I:
			name_str = "Vector4i"
		TYPE_PLANE:
			name_str = "Plane"
		TYPE_QUATERNION:
			name_str = "Quaternion"
		TYPE_AABB:
			name_str = "AABB"
		TYPE_BASIS:
			name_str = "Basis"
		TYPE_TRANSFORM3D:
			name_str = "Transform3D"
		TYPE_PROJECTION:
			name_str = "Projection"
		TYPE_COLOR:
			name_str = "Color"
		TYPE_STRING_NAME:
			name_str = "StringName"
		TYPE_NODE_PATH:
			name_str = "NodePath"
		TYPE_RID:
			name_str = "RID"
		TYPE_OBJECT:
			name_str = "Object"
		TYPE_CALLABLE:
			name_str = "Callable"
		TYPE_SIGNAL:
			name_str = "Signal"
		TYPE_DICTIONARY:
			name_str = "Dictionary"
		TYPE_ARRAY:
			name_str = "Array"
		TYPE_PACKED_BYTE_ARRAY:
			name_str = "PackedByteArray"
		TYPE_PACKED_INT32_ARRAY:
			name_str = "PackedInt32Array"
		TYPE_PACKED_INT64_ARRAY:
			name_str = "PackedInt64Array"
		TYPE_PACKED_FLOAT32_ARRAY:
			name_str = "PackedFloat32Array"
		TYPE_PACKED_FLOAT64_ARRAY:
			name_str = "PackedFloat64Array"
		TYPE_PACKED_STRING_ARRAY:
			name_str = "PackedStringArray"
		TYPE_PACKED_VECTOR2_ARRAY:
			name_str = "PackedVector2Array"
		TYPE_PACKED_VECTOR3_ARRAY:
			name_str = "PackedVector3Array"
		TYPE_PACKED_COLOR_ARRAY:
			name_str = "PackedColorArray"
	return name_str

