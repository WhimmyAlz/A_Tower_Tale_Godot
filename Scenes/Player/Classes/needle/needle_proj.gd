extends Area2D

var speed := Vector2(0, 0)
var size := 2
var lifetime := 10
var direction := Global.player_dir
var angle = 0

var hitnum = 1
var damage = 15
var defense_pen = Global.defense_penetration
var knockback = 15
var knockbackY = 0
var stuntime = 20

var needle_stack_amount = 0

var bleed_chance = 0
var bleed_stacks = 1
var venom_stacks = 0
var shock_stacks = 0

var slices = false
var slicer = false
var vex_regen = false

var player
@onready var needle_node = player.get_node("Class_Actions").get_node("needle")

var slice_preload = preload("res://Scenes/Player/Classes/needle/needle_slice.tscn")

var ult_charge_amount := 10

func set_ult_charge_amount(value):
	ult_charge_amount = value

func charge_ult():
	if Global.ultimate_charge < 1000:
		Global.ultimate_charge = mini(Global.ultimate_charge + ult_charge_amount,  1000)

func set_slicer(value):
	slicer = value

func set_vex_regen(value):
	vex_regen = value

func init_slice():
	var slice = slice_preload.instantiate()
	slice.set_player(player)
	if vex_regen:
		slice.set_pos(position)
		slice.set_vex_regen(true)
	else:
		slice.set_pos(position + Vector2(direction * 100, 0))
		slice.set_size(2.5)
		slice.set_damage(10)
	get_tree().current_scene.get_node("Projectiles").call_deferred("add_child", slice)

func set_slices(value):
	slices = value

func set_speed(x, y):
	speed = Vector2(x * direction, y)

func set_size(sz):
	size = sz

func set_pos(pos):
	position = pos

func set_pos_x(pos):
	position.x = pos

func set_pos_y(pos):
	position.y = pos

func get_pos_x():
	return(position.x)

func get_pos_y():
	return(position.y)

func set_player(ply):
	player = ply

func set_damage(dmg):
	damage = dmg

func set_defense_pen(def_pen):
	defense_pen = def_pen

func set_hitnum(value):
	hitnum = value

func set_direction(dir):
	direction = dir

func set_knockback(kb):
	knockback = kb

func set_knockbackY(kb):
	knockbackY = kb

func set_stuntime(stun_t):
	stuntime = stun_t

func set_lifetime(time):
	lifetime = time

func set_angle(value):
	angle = value

func set_bleed_chance(value):
	bleed_chance = value

func set_bleed(value):
	bleed_stacks = value

func set_venom(value):
	venom_stacks = value

func set_shock(value):
	shock_stacks = value

func needle_stacks(value):
	needle_stack_amount = value

func fix_rotation():
	self.rotation = angle
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false

func _ready() -> void:
	self.scale.x = size
	self.scale.y = size
	fix_rotation()

func _physics_process(_delta: float) -> void:
	self.position += speed
	fix_rotation()
	lifetime -= 1
	
	if lifetime == 0:
		queue_free()
	
	if slicer == true:
		init_slice()

func _on_body_entered(body: Node2D) -> void:
	
	var collider = body
	if collider.is_in_group("attackable") and collider.is_in_group("enemy") and hitnum >= 1:
		charge_ult()
		collider.reset_gravity()
		collider.take_damage(damage, defense_pen)
		collider.take_knockback(knockback, direction)
		collider.take_knockbackY(knockbackY)
		collider.take_stun(stuntime)
		needle_node.add_needle_stacks(needle_stack_amount)
		
		if slices:
			init_slice()
		if venom_stacks > 0:
			collider.inflict_venom(venom_stacks)
		if shock_stacks > 0:
			collider.inflict_shock(shock_stacks)
		if bleed_chance > 0 and randi_range(0,100) < bleed_chance:
			collider.inflict_bleed(bleed_stacks)
		hitnum -= 1
	
	if hitnum == 0:
		queue_free()
