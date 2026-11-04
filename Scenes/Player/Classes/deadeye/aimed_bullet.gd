extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []

var bullet_frag = preload("res://Scenes/Player/Classes/deadeye/bullet_fragment.tscn")
var burn = false

func set_burn(val):
	burn = val

func set_size(sze):
	self.scale.x = sze
	self.scale.y = sze
	size = sze

func _ready() -> void:
	set_status()
	self.scale.x = size
	self.scale.y = size
	$Line2D.points[1] += Vector2(speed[0] * 0.05, speed[1] * 0.05)
	set_angle(speed.angle())
	fix_rotation()

func set_speed(x, y):
	self.speed = Vector2(x, y)

func fix_rotation():
	$AnimatedSprite2D.rotation = angle
	$CollisionShape2D.rotation = angle

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
			collider.take_damage(damage, calc_pierce(collider.get_defense()))
			
			if speed[0] < 0:
				direction = -1
			else:
				direction = 1
			
			collider.take_knockback(knockback, direction)
			collider.take_knockbackY(knockbackY)
			collider.reset_gravity()
			if burn:
				collider.inflict_fire(9)
			collider.take_stun(stuntime)
			already_hit += [collider]
			hitnum -= 1
			
			var fragment = bullet_frag.instantiate()
			
			fragment.set_pos(position.x, position.y)
			fragment.set_angle(angle)
			get_tree().current_scene.get_node("Projectiles").call_deferred("add_child", fragment)

func _physics_process(_delta: float) -> void:
	$Line2D.points[1] -= Vector2(speed[0] * 0.25, speed[1] * 0.25)
	fix_rotation()
	
	self.position += speed * 0.25
	check_hit()
	
	self.position += speed * 0.25
	check_hit()
	
	self.position += speed * 0.25
	check_hit()
	
	self.position += speed * 0.25
	check_hit()

	lifetime -= 1
	if hitnum == 0 or lifetime == 0:
		queue_free()
