extends Node2D

var console_text
var command_lib = {"stats" : 0, "setHealth" : 1, "setStamina" : 1, "spawn" : 2} # has a command name then a 

## Closes and clears the console
func close():
	$LineEdit.clear()
	$".".hide()

## Opens and begins editing the console
func open():
	$".".show()
	$LineEdit.edit()

## Toggles the console's open and clsoed state based on current state
func console_toggle():
	if Input.is_action_just_pressed("Console"):
		if $".".visible:

			if len($LineEdit.text) == 0:
				close()
		else:
			open()

## When console message is sent, logs the message, checks for command and if command is valid, then call the command usage function
func console_return_and_collect():
	if Input.is_action_just_pressed("Console") and len($LineEdit.text) > 0:
		console_text = $LineEdit.text
		log_text(console_text)
		
		if console_text[0] == "/":
			var command = find_and_return()
			var return_val
			if command != null:
				
				# if command_usage is successful, return true, else false
				return_val = command_usage(command)
				if return_val == true:
					close()
				else:
					$LineEdit.edit()
		else:
			$LineEdit.clear()

## Searches to see if command is valid and returns the command and it's arguments if it is
func find_and_return():
	var full_command = console_text.substr(1) # removes "/" of command
	var split_command = full_command.split(" ") # splits command by spaces
	var command = split_command[0]

	if command in command_lib:
		return(full_command.split(" ")) # returns command and args in list form. [command, arguments]

	log_text("Error: Command not found")
	$LineEdit.edit()
	return(null)

## logs the text into the console
func log_text(txt):
	$Console_log.text += "\n" + str(txt)

## Contains many commands that are ran based on whichever argument was provided
func command_usage(txt):
	var command = txt
	
	if command[0] == "stats":
		return(stats(command))
	elif command[0] == "setHealth":
		return(set_health(command))
	elif command[0] == "setStamina":
		return(set_stamina(command))
	elif command[0] == "spawn":
		return(spawn(command))

## returns true or false based on correct amounts of arguments
func arg_check(commands, args):
	if len(commands)-1 == args:
		return(true)
	else:
		log_text("Error: Bad argument amount. Requires ({args}) Argument.".format({"args" : args}))
		return(false)

## Displays some basic game stats
func stats(command):
	var correct_args = arg_check(command, 0)
	if correct_args:
		log_text("FPS: {fps}".format({"fps" : Engine.get_frames_per_second()}))
		return(true)
	else:
		return(false)

## Sets the health of the player
func set_health(command):
	var correct_args = arg_check(command, 1)

	if correct_args:
		var valid = command[1].is_valid_float()
		if float(command[1]) <= 0.0 or not valid:
			log_text("Error: Bad argument type. Requires (Positive int/float: amount) Argument. Value:")
			return(false)
		else:
			Global.health = int(command[1])
			$"../Prog_Bars".Update_HP()
			return(true)
	else:
		return(false)

## Sets the health of the player
func set_stamina(command):
	var correct_args = arg_check(command, 1)
	
	if correct_args:
		var valid = command[1].is_valid_float()
		if float(command[1]) <= 0.0 or not valid:
			log_text("Error: Bad argument type. Requires (Positive int/float: amount) Argument.")
			return(false)
		else:
			Global.stamina = int(command[1])
			$"../Prog_Bars".Update_STAM()
			return(true)
	else:
		return(false)

## Spawns an enemy
func spawn(command):
	var correct_args = arg_check(command, 2)
	
	var skelebone = preload("res://Scenes/Mobs/Skelebone/skelebone.tscn")
	var nerd = preload("res://Scenes/Mobs/Nerd/nerd.tscn")
	var sir_blob = preload("res://Scenes/Bosses/Sir Blob/sir_blob.tscn")
	
	if correct_args:
		var valid = command[2].is_valid_int()
		if int(command[1]) >= 0 and not valid:
			log_text("Error: Bad argument type. Requires (lowercase str:enemy name) and (positive int:enemy level) Argument.")
			return(false)
		else:
			if command[1] == "nerd":
				spawn_enemy(nerd, command[2])
			elif command[1] == "skelebone":
				spawn_enemy(skelebone, command[2])
			elif command[1] == "sir_blob":
				spawn_enemy(sir_blob, command[2])
			else:
				log_text("Enemy name not found.")
				return(false)
			return(true)
		
	else:
		return(false)

func spawn_enemy(enemy_preload, lvl):
	var enemy = enemy_preload.instantiate()
	enemy.set_pos(Vector2(0, 0))
	enemy.Level = int(lvl)
	get_tree().current_scene.get_node("Enemies").add_child(enemy)

func _ready() -> void:
	$Console_log.scroll_following = true

func _physics_process(_delta: float) -> void:
	if visible == true:
		get_parent().get_parent().get_node("PlayerBody").take_stun(2)
	console_toggle()
	console_return_and_collect()
