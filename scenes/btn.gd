tool
extends Button

export(int) var num setget setText
export(Resource) var hover setget setSyleHover
export(Resource) var pressed setget setSylePressed
export(Resource) var normal setget setSyleNormal

export(String, "left", "right") var side

func _ready():
	pass

func _pressed():
	get_node("AnimationPlayer").play("test")
	get_node("/root/game").press(num,side)

func reset():
	set_disabled(false)

func setSylePressed(_newValue):
	pressed = _newValue
	set("custom_styles/pressed",pressed)

func setSyleHover(_newValue):
	hover = _newValue
	set("custom_styles/hover",hover)

func setSyleNormal(_newValue):
	normal = _newValue
	set("custom_styles/normal",normal)

func setText(_newValue):
	num = _newValue
	set_text(str(num))