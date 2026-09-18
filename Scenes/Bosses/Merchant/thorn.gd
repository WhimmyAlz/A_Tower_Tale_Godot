extends Area2D

var size = 3
var proj_speed
var direction 
var proj_life_time = 150
var damage = 15
var final_damage = damage * 0.1
var defense_pen = 10

var speed_multi = 1
var velocity_vector = Vector2(randf_range(-2, 2), randf_range(-1, 1))
var stun_time = 90


@onready var player = get_tree().current_scene.get_node("Player").get_child(0)

## position
func init(pos) -> void:
	position = pos

func set_pos(pos):
	position = pos

func set_damage(value):
	damage = value

func set_final_damage(value):
	final_damage = value

func set_defense_pen(value):
	defense_pen = value

func set_speed_multi(value):
	speed_multi = value
	velocity_vector = Vector2(randf_range(-2 * (1 + 0.1 * speed_multi), 2 * speed_multi), randf_range(-1, 1))

func _ready() -> void:
	self.scale.x = size
	self.scale.y = size

func _physics_process(_delta: float) -> void:
	proj_life_time -= 1

	if proj_life_time >= 90 and proj_life_time <= 150:
		position.y -= (0.25 * (proj_life_time - 90))

		if proj_life_time > 110:
			position += velocity_vector
	
	if proj_life_time >= 140:
		$AnimatedSprite2D.frame = 0

	if proj_life_time >= 80 and proj_life_time <= 110:
		if proj_life_time == 110:
			stun_time = 30
			$ball_collision.disabled = true
			$thorn_collision.disabled = false
			set_final_damage(damage)
			$AnimatedSprite2D.play("looping")
		
		velocity_vector = (player.position - position) * Vector2(0.075, 0.075)
		look_at(player.position)

	if proj_life_time >= 0 and proj_life_time <= 80:
		position += velocity_vector

	if proj_life_time <= 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	var collider = body
	if collider.is_in_group("player") and collider.is_in_group("attackable"):
		collider.take_damage(final_damage, defense_pen)
		collider.take_knockback(0, 1)
		collider.take_stun(stun_time)
		collider.get_status_effect().inflict_shock(10)
		
		if proj_life_time <= 80:
			collider.get_status_effect().inflict_venom(2)
			collider.get_status_effect().inflict_bleed(2)
