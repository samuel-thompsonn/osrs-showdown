extends Node

class_name ActionMenuItem

signal action_requested()

const MOVE = "MOVE"
const ATTACK = "ATTACK"

var label
var type

func _init(label: String, type: String):
	self.label = label
	self.type = type


func activate():
	match type:
		MOVE:
			print("Selected MOVE action")
		ATTACK:
			print("Selected ATTACK action")
	action_requested.emit()
