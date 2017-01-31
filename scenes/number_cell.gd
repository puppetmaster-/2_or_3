tool
extends Node2D

export(int, 0, 9) var num setget setNumber
export(String, "red", "green") var color = "red" setget setColor

func _ready():
	pass
	
func hide_all():
	for c in get_node(color).get_children():
		c.hide()

func setNumber(_number):
	num = _number
	if has_node("red/2"):
		hide_all()
		get_node(color+"/"+str(_number)).show()

func setColor(_newValue):
	color = _newValue
	if has_node("red/2"):
		get_node("red").hide()
		get_node("green").hide()
		get_node(color).show()
		setNumber(num)