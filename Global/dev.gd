extends Node2D

var console_text
var command_lib = {"stats" : 0, "setHealth" : 1, "setStamina" : 1} # has a command name then a 

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
			log_text("Error: Bad argument type. Requires (Positive int/float) Argument. Value:")
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
	
	if correct_args == 2:
		var valid = command[1].is_valid_float()
		if float(command[1]) <= 0.0 or not valid:
			log_text("Error: Bad argument type. Requires (Positive int/float) Argument.")
			return(false)
		else:
			Global.stamina = int(command[1])
			$"../Prog_Bars".Update_STAM()
			return(true)
	else:
		return(false)

func _ready() -> void:
	$Console_log.scroll_following = true

func _physics_process(_delta: float) -> void:
	
	console_toggle()
	console_return_and_collect()
