extends CharacterBody2D
class_name enemyBase

@export var Level := 1

@export var Health = 100.0
@export var Max_Health = Health
@export var Defense = 0

@export var Weight := 50 # used for friction and knockback reduction
@export var Speed := 10
@export var Damage := 10.0
@export var Defense_pen := 0

var damage_text = preload("res://Scenes/Mobs/UI/Damage_text/damage_text.tscn")
var damage_text_offset = Vector2(0, 0)
var player = null

var fire_stacks = 0.0
var fire_tick_delay = 0

var venom_stacks = 0.0
var venom_tick_delay = 0

var shock_stacks = 0.0
var shock_tick_delay = 0

var bleed_stacks = 0.0
var bleed_tick_delay = 0

var deathmark_stacks = 0.0
var deathmark_tick_delay = 0

var direction := 1
var stunnedf := 0 # stunned frames (stunned time shortened)

func set_damage(value):
	Damage = value

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
		if velocity.y >= 15:
			velocity.y = 15
		else:
			velocity.y += Global.Gravity

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

func take_damage(dmg, defense_pen, color = Color.WHITE):
	var def = maxf(Defense - defense_pen, 0)
	var damage =  maxf(dmg - def, 1)

	#sets damage to int if close to x.0 and limits decimals to tenths
	if is_zero_approx(damage - int(damage)):
		damage = int(damage)
	else: 
		damage = snapped(damage, 0.1)

	self.Health = maxf(self.Health - damage, 0)
	$HealthBar.update_value(Health)

	var damageText = damage_text.instantiate()
	damageText.set_text(damage)
	damageText.set_position(position + damage_text_offset)
	damageText.set_color(color)
	get_tree().current_scene.get_node("Damage_text").add_child(damageText)

	if self.Health == 0:
		on_death()

func take_knockback(kb, dir):
	self.velocity.x += kb * dir * 100 # 100 cuz kb too weak otherwise (want to use lower values)

func take_knockbackY(kb):
	if self.velocity.y == 15 and kb < 0:
		self.velocity.y += kb * 50 # during stunned, this affects the enemy a lot less
	else:
		self.velocity.y += kb * 100 # 100 cuz kb too weak otherwise (want to use lower values)

func take_stun(stun_time):
	if shock_stacks == 0 or stunnedf == 0: 
		stunnedf = stun_time
	else:
		stunnedf += int(stun_time * (shock_stacks/100))

## inflict funcs are used for player attacks
func inflict_fire(stacks):
	if fire_stacks <= 50:
		fire_stacks = mini(fire_stacks + stacks, 50)

func inflict_venom(stacks):
	if venom_stacks <= 30:
		venom_stacks = mini(venom_stacks + stacks, 30)

func inflict_shock(stacks):
	if shock_stacks <= 100:
		shock_stacks = mini(shock_stacks + stacks, 100)

func inflict_bleed(stacks):
	if bleed_stacks <= 10:
		bleed_stacks = mini(bleed_stacks + stacks, 10)

func inflict_deathmark(stacks):
	if deathmark_stacks <= 1000:
		deathmark_stacks = mini(deathmark_stacks + stacks, 1000)
		deathmark_tick_delay = 300

## status effects
func take_burn():
	if fire_stacks >= 1 and fire_tick_delay == 0:
		fire_stacks -= 1
		take_damage(fire_stacks / 2, 10, Color.DARK_ORANGE)
		fire_tick_delay = 15
	elif fire_tick_delay > 0:
		fire_tick_delay -= 1

func take_venom():
	if venom_stacks >= 1 and venom_tick_delay == 0:
		venom_stacks -= 1
		take_damage(5, 25, Color.WEB_PURPLE)
		venom_tick_delay = 6
	elif venom_tick_delay > 0:
		venom_tick_delay -= 1

func take_shock():
	var shock_loss = int(shock_stacks/10)
	if shock_stacks >= 1 and shock_tick_delay == 0:
		shock_stacks -= maxi(1, shock_loss)
		shock_tick_delay = 10
	elif shock_tick_delay > 0:
		shock_tick_delay -= 1

func take_bleed():
	if bleed_stacks >= 1 and bleed_tick_delay == 0:
		bleed_stacks -= 1
		bleed_tick_delay = 60
		take_damage(float(Max_Health/100), 1000, Color.DARK_RED)
	elif bleed_tick_delay > 0:
		bleed_tick_delay -= 1

func take_deathmark():
	if deathmark_stacks == 1000:
		take_damage(float(Max_Health/5), 1000, Color.BLACK)
		deathmark_stacks = 0
	elif deathmark_stacks >= 1 and deathmark_tick_delay == 0:
		deathmark_stacks = 0
	elif deathmark_tick_delay > 0:
		deathmark_tick_delay -= 1

func take_all_status_effects():
	take_burn()
	take_venom()
	take_shock()
	take_bleed()
	take_deathmark()

func on_death():
	pass

func set_level_stats():
	pass

func set_dto():
	pass

func check_stats_unchanged():
	if Health == 100 and Defense == 0 and Weight == 50 and Speed == 10 and Defense == 0 and Damage == 10 and Defense_pen == 0:
		return(true)
	else:
		return(false)

func update_hp_bar():
	$HealthBar.update_value(Health)
	$HealthBar.update_max_value(Max_Health)

func _ready() -> void:
	set_level_stats()
	set_dto()
	update_hp_bar()
	set_player_gen_1()
	set_direction(self, player)
