@tool
extends CodeEdit

var clas = ClassDB.get_inheriters_from_class("Node")

func _ready():
	code_completion_enabled = true # 开启代码补全
	text_changed.connect(func():
		request_code_completion(false) # 发送补全请求
	)
	code_completion_requested.connect(func():  # 处理补全请求
		for cla in clas:
			add_code_completion_option(CodeEdit.KIND_CLASS,cla,cla) # 添加选项
		update_code_completion_options(false) # 更新选项
	)
