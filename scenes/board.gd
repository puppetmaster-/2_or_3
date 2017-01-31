
extends Node2D

export(int) var level = 1
export(int) var gameRound = 0
var boolArray = [true,false]
var enemyNumber
var playerNumber
var originalPlayerNumber

var errorCount = 0
var gameTime = 0
var running = false

var level1Numbers = [2,3]
var level2Numbers = [4,5,6]
var level3Numbers = [6,7,8,9,10]
var level8Numbers = [4,6,8,9]

func _ready():
	set_process(true)

func _process(delta):
	if running:
		gameTime += delta

func next_numbers():
	next_round()
	randomize()
	if level == 1: # [+] [+]
		playerNumber = randi()%10+1
		enemyNumber = playerNumber + level1Numbers[randi()%level1Numbers.size()]
	elif level == 2: # [+] [+]
		playerNumber = randi()%20+5
		enemyNumber = playerNumber + level2Numbers[randi()%level2Numbers.size()]
	elif level == 3: # [+] [+]
		playerNumber = randi()%40+10
		enemyNumber = playerNumber + level3Numbers[randi()%level3Numbers.size()]
	elif level == 4: # [-] [-]
		enemyNumber = randi()%10+1
		playerNumber = enemyNumber + level1Numbers[randi()%level1Numbers.size()]
	elif level == 5: # [-] [-]
		enemyNumber = randi()%20+5
		playerNumber = enemyNumber + level2Numbers[randi()%level2Numbers.size()]
	elif level == 6: # [-] [-]
		enemyNumber = randi()%40+10
		playerNumber = enemyNumber + level3Numbers[randi()%level3Numbers.size()]
	elif level == 7: # [*] [*]
		playerNumber = randi()%10+1
		enemyNumber = playerNumber * level1Numbers[randi()%level1Numbers.size()]
	elif level == 8: # [*] [*]
		playerNumber = randi()%15+5
		enemyNumber = playerNumber * level8Numbers[randi()%level8Numbers.size()]
	elif level == 9: # [/] [/]
		enemyNumber = randi()%10+1
		playerNumber = enemyNumber * level1Numbers[randi()%level1Numbers.size()]
	elif level == 10: # [/] [/]
		enemyNumber = randi()%15+5
		playerNumber = enemyNumber * level8Numbers[randi()%level8Numbers.size()]
	originalPlayerNumber = playerNumber
	setNumbers("enemy",enemyNumber)
	setNumbers("player",playerNumber)
	get_node("/root/game").set_running(true)

func same_number():
	errorCount += 1
	playerNumber = originalPlayerNumber
	setNumbers("enemy",enemyNumber)
	setNumbers("player",playerNumber)
	get_node("/root/game").set_running(true)

func setNumbers(_node,_number):
	if _number >= 100:
		get_node(_node+"/3").setNumber(_number/100)
		get_node(_node+"/2").setNumber(_number%100/10)
		get_node(_node+"/1").setNumber(_number%10)
	elif  _number >= 10:
		get_node(_node+"/3").setNumber(0)
		get_node(_node+"/2").setNumber(_number/10)
		get_node(_node+"/1").setNumber(_number%10)
	else:
		get_node(_node+"/3").setNumber(0)
		get_node(_node+"/2").setNumber(0)
		get_node(_node+"/1").setNumber(_number%10)

func press(_mode,_number):
	if level <= 3:
		playerNumber += _number
		get_node("/root/game/sound").play("ok")
		setNumbers("player",playerNumber)
		if playerNumber == enemyNumber:
			get_node("/root/game").set_running(false)
			get_node("/root/game/centerPoint/AnimationPlayer").play("hit")
			get_node("AnimationPlayer").play("new_number")
		if enemyNumber-playerNumber == 1 || playerNumber > enemyNumber:
			get_node("/root/game").set_running(false)
			get_node("AnimationPlayer").play("same_number")
	elif level <= 6:
		playerNumber -= _number
		get_node("/root/game/sound").play("ok")
		setNumbers("player",playerNumber)
		if playerNumber == enemyNumber:
			get_node("/root/game").set_running(false)
			get_node("/root/game/centerPoint/AnimationPlayer").play("hit")
			get_node("AnimationPlayer").play("new_number")
		if playerNumber-enemyNumber == 1 || playerNumber < enemyNumber:
			get_node("/root/game").set_running(false)
			get_node("AnimationPlayer").play("same_number")
	elif level <= 8:
		playerNumber *= _number
		get_node("/root/game/sound").play("ok")
		setNumbers("player",playerNumber)
		if playerNumber == enemyNumber:
			get_node("/root/game").set_running(false)
			get_node("/root/game/centerPoint/AnimationPlayer").play("hit")
			get_node("AnimationPlayer").play("new_number")
		if enemyNumber-playerNumber == 1 || playerNumber > enemyNumber:
			get_node("/root/game").set_running(false)
			get_node("AnimationPlayer").play("same_number")
	elif level <= 10:
		playerNumber /= _number
		get_node("/root/game/sound").play("ok")
		setNumbers("player",playerNumber)
		if playerNumber == enemyNumber:
			get_node("/root/game").set_running(false)
			get_node("/root/game/centerPoint/AnimationPlayer").play("hit")
			if level < 10:
				get_node("AnimationPlayer").play("new_number")
			else:
				running = false
				get_node("/root/game/centerPoint/AnimationPlayer").play("gameOver")
		if playerNumber-enemyNumber == 1 || playerNumber < enemyNumber:
			get_node("/root/game").set_running(false)
			get_node("AnimationPlayer").play("same_number")

func next_round():
	if gameRound < 5:
		gameRound +=1
	else:
		level += 1
		#change button mode 
		if level == 4:
			get_node("/root/game").set_running(false)
			get_node("/root/game").set_button_mode(1,"min")
			get_node("/root/game").set_button_mode(2,"min")
		elif level == 7:
			get_node("/root/game").set_running(false)
			get_node("/root/game").set_button_mode(1,"mul")
			get_node("/root/game").set_button_mode(2,"mul")
		elif level == 9:
			get_node("/root/game").set_running(false)
			get_node("/root/game").set_button_mode(1,"div")
			get_node("/root/game").set_button_mode(2,"div")
		gameRound = 1
	#visual game round
	for r in get_node("/root/game/centerPoint/round").get_children():
		r.hide()
	get_node("/root/game/centerPoint/round").get_node(str(gameRound)).show()
	#visual level
	for l in get_node("/root/game/centerPoint/blueWall/level").get_children():
		if int(l.get_name()) <= level:
			l.show()
		else:
			l.hide()
	get_node("/root/game/centerPoint/round").get_node(str(gameRound)).show()

func playSound(_titel):
	get_node("/root/game/sound").play(_titel)

func game_end():
	get_node("player").hide()
	get_node("enemy").hide()
	get_node("game").hide()
	
	# show error
	get_node("end/e1").setNumber(errorCount%10)
	get_node("end/e2").setNumber((errorCount-(errorCount%10))/10)
	
	#show gameTime
	var _sec = int(gameTime)%60
	var _min = int((gameTime-_sec)/60)
	get_node("end/ms1").setNumber(int(gameTime*10)%10)
	get_node("end/s1").setNumber(_sec%10)
	get_node("end/s2").setNumber(int(_sec/10))
	get_node("end/m1").setNumber(_min%10)
	get_node("end/m2").setNumber(int(_min/10))

func startGame():
	gameTime = 0
	running = true
	next_numbers()
