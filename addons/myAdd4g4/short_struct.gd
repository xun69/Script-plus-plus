@tool
extends HBoxContainer
@onready var txt = $txt
@onready var insert_btn = $InsertBtn

var NodeAddPlugin = preload("res://addons/myAdd4g4/class/sub_class/NodeAddPlugin.gd").new()

func _ready():
	insert_btn.pressed.connect(func():
		NodeAddPlugin.add_nodes_by_short_struct(txt.text)
		txt.text = ""
	)
