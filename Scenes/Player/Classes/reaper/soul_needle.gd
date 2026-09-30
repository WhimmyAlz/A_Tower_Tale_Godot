extends "res://Scenes/Player/Classes/projectile_base.gd"

var collided = false

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
		look_at(target.position)
		speed = (target.position - position) * 0.1
		
	if lifetime < 10:
		scale *= 0.9
	
	if lifetime < 40:
		if not collided:
			position += speed
		for collider in collisions:
			if collider.is_in_group("attackable") and collider.is_in_group("enemy") and (only_collider == null or collider == only_collider) and hitnum >= 1:
				collided = true
				if lifetime % 10 == 0:
					only_collider = collider
					collider.take_damage(damage, defense_pen, 0)
					collider.take_stun(stuntime)
					collider.take_knockback(0, 0)
					collider.inflict_deathmark(25)
					collider.reset_gravity()
					hitnum -= 1
			
