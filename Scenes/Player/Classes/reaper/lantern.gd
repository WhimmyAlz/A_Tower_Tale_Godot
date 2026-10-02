extends Node2D

var attacking = false

func _physics_process(_delta: float) -> void:
	rotation -= 0.01

func get_attacking():
	return(attacking)

func attack():
	attacking = true
	$AnimatedSprite2D.play("attack")

var explosion_preload = preload("res://Scenes/Player/Classes/reaper/explosion.tscn")

func spawn_explosion(collider):
	var explosion = explosion_preload.instantiate()
	explosion.set_damage(Global.power * 0.25)
	explosion.set_knockback(1)
	explosion.set_pos(collider.position + Vector2(randi_range(-100,100),randi_range(-250,250)))
	explosion.set_lifetime(50)
	explosion.set_stuntime(0)
	explosion.set_ult_charge_amount(0)
	explosion.set_size(randi_range(2,6))
	if randi_range(1,10) == 1:
		explosion.set_damage(Global.power * 2)
		explosion.set_size(randi_range(16, 18))
	explosion.set_hitnum(100)
	explosion.set_angle(randi_range(1,360))
	explosion.set_early_explosion(3)
	get_tree().current_scene.get_node("Projectiles").call_deferred("add_child",explosion)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		attacking = false
		var enemy_list = get_tree().current_scene.get_node("Enemies")
		if enemy_list.get_child_count() > 0:
			var target = enemy_list.get_child(randi_range(0, enemy_list.get_child_count()-1))
			spawn_explosion(target)
			$AnimatedSprite2D.play("idle")
