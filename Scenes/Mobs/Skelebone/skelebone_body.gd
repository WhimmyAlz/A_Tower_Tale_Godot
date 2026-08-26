extends enemyBase

var bone = preload("res://Scenes/Mobs/Skelebone/bone.tscn")
var attackt = 0

var skeleton_animation

func move(animation):
	skeleton_animation = animation

	animation.speed_scale = Speed * 0.1
	if self.is_on_floor():
		animation.play("walk")
	else:
		animation.play("idle")

	if animation.frame >= 3 and animation.frame <= 4:
		if self.is_on_floor(): # only move the skeleton x position if on ground
			self.position.x += 0.2 * Speed * direction
			face_player(animation)

	set_direction(self, player)

func throw_bone():
	var projectile = bone.instantiate()
	var proj_position = self.position + Vector2(self.direction * 6, -100)
	var proj_speed = 10 + abs(self.position.x - player.position.x) * 0.005
	var proj_lifetime = 90
	
	projectile.init(proj_position, proj_speed, self.direction, proj_lifetime)
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)

func on_death():
	player.gain_xp(10)
	queue_free()

func _ready() -> void:
	set_player_gen_1()
	set_direction(self, player)

func _physics_process(_delta: float) -> void:
	
	if attackt >= 0 and attackt <= 133:
		if stunnedf == 0:
			move($SkeleboneSprite)
			attackt += 1
		else:
			skeleton_animation.play("idle")
			skeleton_animation.pause()
			stunnedf -= 1
		
	elif attackt >= 134 and attackt <= 180:
		stunnedf = 0
		
		if attackt == 134:
			face_player(skeleton_animation)
			$SkeleboneSprite.play("attack")
		
		if attackt == 174:
			throw_bone()
	
		attackt += 1
	if attackt >= 180:
		attackt = 0

	friction()
	vert_velocities()
	move_and_slide()
