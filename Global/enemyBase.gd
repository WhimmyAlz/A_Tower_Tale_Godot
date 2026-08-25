extends CharacterBody2D
class_name enemyBase

@export var Health := 100
@export var Max_Health := Health
@export var Weight := 50 # used for friction and knockback reduction
@export var Speed := 10

@export var player = null

var direction := 1
var stunnedf := 0 # stunned frames (stunned time shortened)

func get_health():
	return(Health)

func get_max_health():
	return(Max_Health)

func set_player_gen_1():
	player = get_tree().current_scene.get_node("Player").get_child(0)

func set_direction(base, other):
	if base.position.x > other.position.x:
		direction = -1
	elif base.position.x < other.position.x:
		direction = 1

func face_player(animation):
	if direction == -1:
		animation.flip_h = false
	elif direction == 1:
		animation.flip_h = true

func vert_velocities():
	if stunnedf > 1:
		stunnedf -= 1
	else:
		velocity.y += Global.Gravity

func friction():
	if velocity.x > Weight:
		velocity.x -= Weight
	elif velocity.x < -Weight:
		velocity.x += Weight
	else:
		velocity.x = 0

func move(animation):
	animation.play("walk")
	if self.position.x > player.position.x:
		self.position.x -= Speed
		animation.flip_h = false
	elif self.position.x < player.position.x:
		self.position.x += Speed
		animation.flip_h = true

func take_damage(dmg):
	self.Health = maxi(self.Health - dmg, 0)
	$HealthBar.update_value(Health)
	
	if self.Health == 0:
		on_death()

func take_knockback(kb, dir):
	self.velocity.x += kb * dir * 100 # 100 cuz kb too weak otherwise (want to use lower values)

func take_stun(stun_time):
	stunnedf = stun_time

func on_death():
	pass
