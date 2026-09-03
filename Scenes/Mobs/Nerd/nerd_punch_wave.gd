extends Area2D

var size = 3
var proj_speed
var direction 
var proj_life_time = 10
var damage = 15
var defense_pen = 0

var velocity_vector

## position, speed, direction, lifetime
func init(pos, speed, dir, time) -> void:
	position = pos
	proj_speed = speed
	direction = dir
	proj_life_time = time

func set_pos(pos):
	position = pos

func set_speed(speed):
	proj_speed = speed

func set_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite2D.flip_h = true

func set_damage(value):
	damage = value

func set_defense_pen(value):
	defense_pen = value

func _ready() -> void:
	self.scale.x = size
	self.scale.y = size

func _physics_process(_delta: float) -> void:
	position.x += proj_speed * direction
	
	proj_life_time -= 1
	if proj_life_time <= 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	var collider = body

	if collider.is_in_group("player") and collider.is_in_group("attackable"):
		collider.take_damage(damage, defense_pen)
		collider.take_knockback(10, direction)
		collider.take_stun(30)
