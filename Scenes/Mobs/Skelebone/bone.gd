extends CharacterBody2D

var size = 4
var spin_speed = 0.2
var proj_speed
var direction
var proj_life_time
var damage = 25

var velocity_y = -9
var gravity = 0.4

var velocity_vector

## position, speed, direction, lifetime
func init(pos, speed, dir, time) -> void:
	position = pos
	proj_speed = speed
	direction = dir
	proj_life_time = time

func set_vert_velocity(value):
	velocity_y = value

func _ready() -> void:
	self.scale.x = size
	self.scale.y = size

func _physics_process(_delta: float) -> void:
	self.rotation += spin_speed
	
	proj_life_time -= 1
	if proj_life_time <= 0:
		queue_free()
	
	velocity_vector = Vector2(proj_speed * direction, velocity_y)
	velocity_y += gravity

	var colision = move_and_collide(velocity_vector)

	if colision:

		var collider = colision.get_collider()

		if collider.is_in_group("player") and collider.is_in_group("attackable"):
			collider.take_damage(damage)
			collider.take_knockback(5, direction)
			collider.take_stun(15)
			queue_free()
