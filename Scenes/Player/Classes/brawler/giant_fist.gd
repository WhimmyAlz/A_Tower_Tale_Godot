extends "res://Scenes/Player/Classes/projectile_base.gd"

var shockwave_preload = preload("res://Scenes/Player/Classes/brawler/giant_shockwave.tscn")

func init_shockwave():
	var shockwave = shockwave_preload.instantiate()
	shockwave.set_player(player)
	shockwave.set_size(15)
	shockwave.set_damage(damage * 0.75)
	shockwave.set_pos(Vector2(position.x, 850))
	get_tree().current_scene.get_node("Projectiles").call_deferred("add_child", shockwave)

func _ready() -> void:
	fix_rotation()
	self.scale.x = size
	self.scale.y = size

func _physics_process(_delta: float) -> void:
	self.position += speed
	fix_rotation()
	lifetime -= 1
	if lifetime == 30:
		init_shockwave()
	if lifetime == 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	
	var collider = body
	if collider.is_in_group("attackable") and collider.is_in_group("enemy") and hitnum >= 1:
		collider.take_damage(damage, defense_pen)
		collider.take_knockback(knockback, direction)
		collider.take_knockbackY(knockbackY)
		collider.take_stun(stuntime)
		hitnum -= 1
