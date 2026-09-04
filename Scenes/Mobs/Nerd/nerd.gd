extends enemyBase

var wave_preload = preload("res://Scenes/Mobs/Nerd/nerd_punch_wave.tscn")
var attackt = -1

var stats_offset = Vector2(-200, -60)

var typewriter_value = 0
var fun_facts = [
"[b]Hey did you know that you can hover your mouse over things to get information on them?[/b]", "[b]Hey did you know that this game was a remake of a highschool project which was made using code.org?[/b]", "[b]Hey did you know that I can drop between 20 and 30 xp or a new attack?[/b]", "[b]Hey did you know that the skeleton is actually only throwing his arm bone which he somehow regrows?[/b]", "[b]Erm actually...[/b]", "[b]Glub Glub.[/b]", "[b]Does anything else in this tower talk? None of the ones on the floors that I'm on do.[/b]","[b]According to all known laws of aviation, there is no way a bee should be able to fly. Its wings are too small to get its fat little body off the ground. The bee...[/b]", "[b]So let's say something has a 10% drop chance and you didn't get it in 10 attempts. The chance of that happening is 34.86784401%.[/b]",
"[b]I used to look less nerdy and had soft poop colored hair, but that was before this game.[/b]", "[b]Did you know that cows have 3 stomaches? Interesting right?[/b]", "[b]In the old game, the game's lore was that all the characters were students role playing and the tower game was just a story book.[/b]","[b]If you want to play the original highschool project game, then you can just [i][url=https://studio.code.org/projects/gamelab/A-puNJUHMBbGf_pQGUwswzV_g6rH6wro0fhe6y7M_mE]Click Here[/url][/i][/b]", "[b]I must confess that I feel like a monster...[/b]", "[b]You should put the peashooter behind the sunflower since the sunflower costs less and pays for itself that way.[/b]", "[b]The bleed status effect takes 1% of your max hp per second, but you probably already know that if you read the status effect list.[/b]", "[b]Did you know that you can hold S to fall faster once you start falling?[/b]",
"[b]You don't wanna catch these fisticuffs, buddyo.[/b]"
]

var fun_facts_pick = randi_range(0, len(fun_facts)-1)
var fun_facts_pick_cd = 420

@onready var animation = $NerdSprite

func add_num_fact():
	fun_facts += ["[b]I have %d different things to talk about so if I'm repeating myself then I'm just annoying you.[/b]" % (len(fun_facts) + 1)]
	fun_facts_pick = randi_range(0, len(fun_facts)-1)

func set_description():
	description = "[b]Nerd[/b]\nLevel: %d\n\n[i]\"Erm Ackually..\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nA typical Nerd. Hopefully he doesn't try to talk to me.\n\nDrops:\n10%% Ultimate attack\n\nMutually Exclusive drops:\n%.01f%% New attack\n%.01f%% 20-30 xp" % [Level, Health, Damage, Defense, Defense_pen, (100/float(Global.player_attacks)), (100 - 100/float(Global.player_attacks))]

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
	if Global.player_attacks < 5 and 100/float(Global.player_attacks) >= randi_range(1, 100):
		player.unlock_attack(1)
	else:
		player.gain_xp(randi_range(20, 30))

	if Global.ultimate_attack == 0 and 10 >= randi_range(1, 100):
		player.unlock_ultimate()

	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 100 + (level * 50)
		Max_Health = 100 + (level * 50)
		
		Damage = 25 + (level * 5)
		
		update_hp_bar()
	
	set_description()
	add_num_fact()
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(2.8)
	$EnemyStatsList.set_text(description)
	$fun_facts/display/text.text = fun_facts[fun_facts_pick]

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

func typewriter():
	if typewriter_value < len(fun_facts[fun_facts_pick]):
		typewriter_value += 1

	else:
		fun_facts_pick_cd -= 1

		if fun_facts_pick_cd == 120:
			$fun_facts/display.visible = false

		if fun_facts_pick_cd == 0:
			$fun_facts/display.visible = true
			typewriter_value = 0
			fun_facts_pick = randi_range(0, len(fun_facts)-1)
			$fun_facts/display/text.text = fun_facts[fun_facts_pick]
			fun_facts_pick_cd = 420

			if direction == -1:
				$fun_facts/display.flip_h = false
				$fun_facts/display.position = Vector2(-270, -214)
			else:
				$fun_facts/display.flip_h = true
				$fun_facts/display.position = Vector2(270, -214)


	$fun_facts/display/text.visible_characters = typewriter_value

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
	
	typewriter()
	
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


func _on_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
