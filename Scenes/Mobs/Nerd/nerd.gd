extends enemyBase

var wave_preload = preload("res://Scenes/Mobs/Nerd/nerd_punch_wave.tscn")
var attackt = -1

var stats_offset = Vector2(300, -20)

@onready var animation = $NerdSprite

func set_description():
	description = "[b]Nerd[/b]\nLevel: %d\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nA Nerd. Not very dexterous but still punches pretty hard. Maybe his book of cursed knowledge and doom will give you something useful?" % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(_anim):
	# move
	if self.position.x > player.position.x + 100:
		self.position.x -= Speed
		animation.play("walk")
	elif self.position.x < player.position.x - 100:
		self.position.x += Speed
		animation.play("walk")
	else:
		animation.play("idle")

	# flip
	if self.position.x > player.position.x:
		animation.flip_h = false
	elif self.position.x < player.position.x:
		animation.flip_h = true

	set_direction(self, player)

func punch():
	var wave = wave_preload.instantiate()
	wave.set_pos(position + Vector2(30 * direction, -35))
	wave.set_speed(15)
	wave.set_direction(direction)
	wave.set_damage(Damage)
	get_tree().current_scene.get_node("Projectiles").add_child(wave)

func on_death():
	player.gain_xp(randi_range(10, 20))
	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 100 + (level * 20)
		Max_Health = 100 + (level * 20)
		
		Damage = 15 + (level * 1)
		
		update_hp_bar()
	
	set_description()
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(2.8)
	$EnemyStatsList.set_text(description)

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -300)

func take_stun(stun_time):
	if attackt == -1:
		attackt = 0
	if shock_stacks == 0 or stunnedf == 0: 
		stunnedf = stun_time
	else:
		stunnedf += int(stun_time * (shock_stacks/100))

func _physics_process(_delta: float) -> void:
	if attackt >= 0 and attackt <= 119:
		if stunnedf == 0:
			move(animation)
			attackt += 1
		else:
			animation.play("idle")
			animation.pause()
			stunnedf -= 1
		
	elif attackt >= 120 and attackt <= 170:
		if attackt == 120:
			face_player(animation)
			animation.play("attack")
		
		if attackt == 160:
			punch()
	
		attackt += 1
	if attackt >= 170:
		attackt = 0
	
	take_all_status_effects()
	
	spawn_frames()
	friction()
	vert_velocities()
	move_and_slide()
	
	if mouse_over:
		update_description()

func update_description():
	set_description()
	$EnemyStatsList.set_text(description)
	$EnemyStatsList.fix_pos(direction)

func _on_mouse_entered() -> void:
	$EnemyStatsList.visible = true
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false
	$EnemyStatsList.visible = false
