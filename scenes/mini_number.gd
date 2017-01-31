tool
extends Node2D

export(int, 0, 9) var num setget setNumber

func _ready():
	pass

func setNumber(_number):
	if _number > 9:
		_number = 9
	num = _number
	if has_node("0"):
		hide_all()
		get_node(str(_number)).show()

func hide_all():
	for n in get_children():
		n.hide()