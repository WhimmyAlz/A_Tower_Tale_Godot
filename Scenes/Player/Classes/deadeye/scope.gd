extends AnimatedSprite2D

var lifetime = 180
var player = null
var target = null
var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_damage(val):
	damage = val

func set_player(val):
	player = val

func set_target(val):
	target = val

func _process(_delta: float) -> void:
	lifetime -= 1

	if target != null:
		position = target.position
	
	if lifetime == 60:
		$".".play()

func fire():
	var bullet = preload("res://Scenes/Player/Classes/deadeye/aimed_bullet.tscn").instantiate()
	
	var bullet_pos = Vector2(0, 0)
	
	if randi_range(0, 1) == 0:
		if randi_range(0, 1) == 0:
			# spawn randomly on left side
			bullet_pos = Vector2(randi_range(-1500, -1000), randi_range(-1500, 1500))
		else:
			# spawn randomly on right side
			bullet_pos = Vector2(randi_range(1000, 1500), randi_range(-1500, 1500))
	else:
		if randi_range(0, 1) == 0:
			# spawn randomly on top
			bullet_pos = Vector2(randi_range(-1500, 1500), randi_range(-1500, -1000))
		else:
			# spawn randomly on bottom
			bullet_pos = Vector2(randi_range(-1500, 1500), randi_range(1000, 1500))
		
	
	var direction = (position - bullet_pos).normalized()
	
	bullet.set_player(player)
	bullet.set_damage(damage)
	bullet.set_knockback(3)
	bullet.set_pos(bullet_pos)
	bullet.set_stuntime(12)
	bullet.set_hitnum(100)
	bullet.set_speed(350 * direction[0], 350 * direction[1])
	bullet.set_lifetime(100)
	bullet.set_ult_charge_amount(35)

	get_tree().current_scene.get_node("Projectiles").call_deferred("add_child", bullet)

func _on_animation_finished() -> void:
	if animation == "shoot":
		fire()
		queue_free()
