tool
extends Node2D

export(int, 2, 3) var num setget setNumber
export(String, "add", "min", "div", "mul") var mode = "add" setget setMode
var newMode = "add"

func _ready():
	get_node("TextureButton").connect("pressed",self,"_pressed")


func setNumber(_newValue):
	num = _newValue
	if has_node("2"):
		get_node("2").hide()
		get_node("3").hide()
		get_node(str(num)).show()

	
func setMode(_newValue):
	mode = _newValue
	if has_node("2"):
		var tmpNode = get_node(str(num))
		tmpNode.get_node("add").hide()
		tmpNode.get_node("min").hide()
		tmpNode.get_node("div").hide()
		tmpNode.get_node("mul").hide()
		tmpNode.get_node(mode).show()

func setNewMode():
	get_node("/root/game").set_running(true)
	setMode(newMode)

func _pressed():
	get_node("/root/game").set_button_pressed_with_mouse(num)

func startRocket():
	get_node("2/shoot").show()
	get_node("3/shoot").show()

func stopRocket():
	get_node("2/shoot").hide()
	get_node("3/shoot").hide()