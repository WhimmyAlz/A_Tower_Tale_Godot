extends Area2D

var size = 1
var proj_speed
var direction 
var proj_life_time = 142
var damage = 15
var defense_pen = 10

var speed_multi = 1
var velocity_vector = Vector2(30, 0)
var stun_time = 30
var hitnum = 1

## position
func set_direction(dir) -> void:
	direction = dir
	
	if dir == -1:
		$AnimatedSprite2D.flip_h = true

func set_pos(pos):
	position = pos

func set_damage(value):
	damage = value

func set_defense_pen(value):
	defense_pen = value

func _ready() -> void:
	self.scale.x = size
	self.scale.y = size

func _physics_process(_delta: float) -> void:
	proj_life_time -= 1

	if proj_life_time < 140:
		position += direction * velocity_vector
	else:
		position -= direction * velocity_vector * Vector2(0.025, 1)

	if proj_life_time <= 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	var collider = body
	if collider.is_in_group("player") and collider.is_in_group("attackable") and proj_life_time < 140:
		collider.take_damage(damage, defense_pen)
		collider.take_knockback(10, direction)
		collider.take_stun(stun_time)
		hitnum = 0
