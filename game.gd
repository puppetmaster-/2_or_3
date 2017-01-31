
extends CenterContainer

var number 
var numbers = []
var oldNumber = 0
var nr1 = 2
var nr2 = 3
var turn = 0

## input varialbles
var input_handling = preload("scripts/input_handling.gd")
var key_left_input = input_handling.new("btn_left","action")
var key_right_input = input_handling.new("btn_right","action")
var key_left
var key_right

var key_left_mouse = false
var key_right_mouse = false

## gamestates
var running = false
var intro = false

#nodes
onready var btn1 = get_node("centerPoint/btn1/button")
onready var btn2 = get_node("centerPoint/btn2/button")
onready var boardNode = get_node("centerPoint/board")
onready var backgroundMusic = get_node("backgroundMusic")
onready var backgroundMusicTimer = get_node("backgroundMusic/loopTimer")


func _ready():
	backgroundMusic.connect("finished",self,"_finishPlaying")
	backgroundMusicTimer.connect("timeout",self,"_timeout")
	btn1.num = 2
	btn2.num = 3
	btn1.mode = "add"
	btn2.mode = "add"
	set_process(true)

func _process(delta):
	if running:
		key_left = key_left_input.check()
		key_right = key_right_input.check()
		
		if key_left in [1] || key_left_mouse:
			boardNode.press(btn1.mode,2)
			key_left_mouse = false
			if get_node("centerPoint/btn1/button/AnimationPlayer").is_playing():
				if get_node("centerPoint/btn1/button/AnimationPlayer").get_current_animation() != "change":
					get_node("centerPoint/btn1/button/AnimationPlayer").play("press") 
			else:
				get_node("centerPoint/btn1/button/AnimationPlayer").play("press")
		elif key_right in [1] || key_right_mouse:
			key_right_mouse = false
			boardNode.press(btn2.mode,3)
			if get_node("centerPoint/btn2/button/AnimationPlayer").is_playing():
				if get_node("centerPoint/btn2/button/AnimationPlayer").get_current_animation() != "change":
					get_node("centerPoint/btn2/button/AnimationPlayer").play("press")
			else:
				get_node("centerPoint/btn2/button/AnimationPlayer").play("press")
	if intro:
		key_left = key_left_input.check()
		key_right = key_right_input.check()
		if key_left in [1] || key_left_mouse:
			intro = false
			get_node("AnimationPlayer").play("intro_to_menu")
		elif key_right in [1] || key_right_mouse:
			intro = false
			get_node("AnimationPlayer").play("intro_to_menu")

func set_running(_bool):
	running = _bool

func startTheGame():
	boardNode.startGame()

func set_button_mode(_btn_nr,_mode):
	if _btn_nr == 1:
		btn1.newMode = _mode
		get_node("centerPoint/btn1/button/AnimationPlayer").play("change")
	else:
		btn2.newMode = _mode
		get_node("centerPoint/btn2/button/AnimationPlayer").play("change")

func playSound(_titel):
	get_node("gameStartSound").play(_titel)

func set_button_pressed_with_mouse(_number):
	if running:
		if _number == 2:
			key_left_mouse = true 
		else:
			key_right_mouse = true 

func setIntro(_status):
	intro = _status

func _finishPlaying():
	backgroundMusicTimer.set_wait_time(randi()%20+10)
	backgroundMusicTimer.start()

func _timeout():
	 backgroundMusic.play()