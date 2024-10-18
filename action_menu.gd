extends PopupMenu

class_name ActionMenu

var actions: Array[ActionMenuItem]

func initialize_menu(actions: Array[ActionMenuItem], position: Vector2):
	self.actions = actions
	self.position = position
	print("Initializing menu")
	for action in actions:
		add_item(action.label)


func _on_index_pressed(index):
	var a = self.actions[index]
	a.activate()
