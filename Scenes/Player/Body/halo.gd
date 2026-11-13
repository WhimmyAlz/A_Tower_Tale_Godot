extends AnimatedSprite2D

@onready var player = $"../.."

var levitate_mode = 1
var levitatet = 10

func _process(_delta: float) -> void:
	var hat_check = false
	
	if player.get_attacking():
		hat_check = Global.player_dir == -1
	else :
		hat_check = player.get_anim_flip()

	if hat_check:
		self.position.x = 4
	else:
		self.position.x = -4
	
	self.position.y += 0.25 * levitate_mode
	
	if levitatet > 0:
		levitatet -= 1
	
	if levitatet == 0:
		levitate_mode *= -1
		levitatet = 20
