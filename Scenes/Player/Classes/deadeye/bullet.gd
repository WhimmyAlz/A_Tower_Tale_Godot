extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []

var bullet_frag = preload("res://Scenes/Player/Classes/deadeye/bullet_fragment.tscn")
var bullet_fall = false

var falling_bullet_proj = preload("res://Scenes/Player/Classes/deadeye/falling_bullet.tscn")

func set_bullet_fall(val):
	bullet_fall = val

func _ready() -> void:
	set_status()
	self.scale.x = size
	self.scale.y = size
	$Line2D.points[1] += Vector2(speed[0] * 0.2, 0)
	fix_rotation()

func spawn_falling_bullet(pos, i=0):
	var falling_bullet = falling_bullet_proj.instantiate()
	falling_bullet.set_player(player)
	falling_bullet.set_damage((0.2 * Global.power) + (0.2 * Global.dexterity))
	falling_bullet.set_knockback(0, 1)
	falling_bullet.set_pos(pos + Vector2(randi_range(-100, 100), -1000 + (i * -500)))
	falling_bullet.set_stuntime(10)
	falling_bullet.set_hitnum(1)
	falling_bullet.set_speed(0, 190)
	falling_bullet.set_lifetime(60)
	falling_bullet.set_ult_charge_amount(10)

	get_tree().current_scene.get_node("Projectiles").call_deferred("add_child", falling_bullet)


func check_hit():
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = $CollisionShape2D.shape
	query.transform = $CollisionShape2D.global_transform
	query.collision_mask = collision_mask
	
	var collisions = get_world_2d().direct_space_state.intersect_shape(query)
	
	for collision in collisions:
		var collider = collision.collider
		if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
			charge_ult()
			if collider.take_damage(damage, calc_pierce(collider.get_defense())) and not bullet_fall:
				Global.stamina = minf(Global.stamina + (Global.max_stamina * 0.2), Global.max_stamina)
			collider.take_knockback(knockback, direction)
			collider.take_knockbackY(knockbackY)
			collider.reset_gravity()
			collider.take_stun(stuntime)
			already_hit += [collider]
			hitnum -= 1
			
			var fragment = bullet_frag.instantiate()
			
			fragment.set_pos(position.x, position.y)
			fragment.set_dir(direction)
			get_tree().current_scene.get_node("Projectiles").call_deferred("add_child", fragment)
			
			if bullet_fall:
				for i in range(15):
					spawn_falling_bullet(collider.position, i)

func _physics_process(_delta: float) -> void:
	$Line2D.points[1] -= Vector2(speed[0] * 0.2, 0)
	fix_rotation()
	
	self.position += speed * 0.5
	check_hit()
	
	self.position += speed * 0.5
	check_hit()

	lifetime -= 1
	if hitnum == 0 or lifetime == 0:
		queue_free()
