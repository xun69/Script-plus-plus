extends Tree


func _ready():
	var itm = create_item()
	
	itm.set_cell_mode(0,TreeItem.CELL_MODE_CHECK)
	itm.set_checked(0,true)
	itm.set_text(0,"hahah")
	pass




func _on_item_selected():
	var sel:TreeItem = get_selected()
	sel.set_checked(0,not sel.is_checked(0))
