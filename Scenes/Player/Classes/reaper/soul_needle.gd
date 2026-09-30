extends "res://Scenes/Player/Classes/projectile_base.gd"

var collided = false
var piercing_needle = false
var predetermined_target = null

var explosion_preload = preload("res://Scenes/Player/Classes/reaper/explosion.tscn")

func spawn_explosion(collider):
	var explosion = explosion_preload.instantiate()
	explosion.set_damage(0)
	explosion.set_knockback(0)
	collider.reset_gravity()
	explosion.set_pos(collider.position + Vector2(randi_range(-100,100),randi_range(-250,250)))
	explosion.set_speed(0, 0)
	explosion.set_lifetime(50)
	explosion.set_stuntime(60)
	explosion.set_ult_charge_amount(0)
	explosion.set_size(randi_range(2,6))
	explosion.set_hitnum(100)
	explosion.set_early_explosion(randi_range(1,3))
	get_tree().current_scene.get_node("Projectiles").call_deferred("add_child",explosion)

func set_piercing_needle(val):
	piercing_needle = val

func set_target(val):
	predetermined_target = val

func _ready() -> void:
	scale.y = size
	scale.x = size

func _physics_process(_delta: float) -> void:
	lifetime -= 1
	
	if lifetime == 0:
		queue_free()

	var collisions = self.get_overlapping_bodies()
	var only_collider = null
	
	if lifetime == 40:
		var enemy_list = get_tree().current_scene.get_node("Enemies")
		var target = enemy_list.get_child(randi_range(0, enemy_list.get_child_count()-1))
		if predetermined_target != null:
			target = predetermined_target
		look_at(target.position)
		speed = (target.position - position) * 0.1
		
	if lifetime < 10:
		scale *= 0.9
	
	if lifetime < 40:
		if not collided or piercing_needle:
			position += speed
		for collider in collisions:
			if collider.is_in_group("attackable") and collider.is_in_group("enemy") and (only_collider == null or collider == only_collider) and hitnum >= 1:
				collided = true
				if lifetime % 10 == 0:
					only_collider = collider
					if predetermined_target != null:
						for i in range(3):
							spawn_explosion(collider)
						if collider.Boss == true:
							collider.take_damage(collider.Health/15, defense_pen, 0)
						else:
							collider.take_damage(collider.Max_Health/10, defense_pen, 0)
					else:
						collider.take_damage(damage, defense_pen, 0)
						collider.inflict_deathmark(25)
					collider.take_stun(stuntime)
					collider.take_knockback(0, 0)
					collider.reset_gravity()
					hitnum -= 1
