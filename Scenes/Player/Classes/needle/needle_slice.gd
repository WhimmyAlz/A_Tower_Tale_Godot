extends Area2D

var speed := Vector2(0, 0)
var size := 2
var lifetime := 10
var angle = randi_range(0, 360)

var hitnum = 1
var damage = 5
var defense_pen = 10

var bleed_stacks = 1
var vex_regen = false

var player
@onready var needle_node = player.get_node("Class_Actions").get_node("needle")

func set_vex_regen(value):
	vex_regen = value

func set_size(sz):
	size = sz

func set_pos(pos):
	position = pos

func set_player(ply):
	player = ply

func set_damage(dmg):
	damage = dmg

func set_defense_pen(def_pen):
	defense_pen = def_pen

func set_hitnum(value):
	hitnum = value

func set_lifetime(time):
	lifetime = time

func set_angle(value):
	angle = value

func set_bleed(value):
	bleed_stacks = value

func _ready() -> void:
	self.rotation = angle
	self.scale = Vector2(size, size)

func _physics_process(_delta: float) -> void:
	lifetime -= 1
	
	if lifetime == 0:
		queue_free()
	
	var collisions = self.get_overlapping_bodies()
	
	for collider in collisions:
		if collider.is_in_group("attackable") and collider.is_in_group("enemy") and hitnum >= 1:
			if vex_regen and Global.stamina != Global.max_stamina:
				player.gain_stamina(Global.max_stamina/10)
			else:
				needle_node.add_needle_stacks(1)
			collider.take_damage(damage, defense_pen, 0)
			collider.inflict_bleed(1)
			hitnum -= 1
