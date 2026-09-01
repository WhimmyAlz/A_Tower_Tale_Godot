extends Node2D

var player_class = Global.player_class
@onready var class_node = $brawler

var animation
var hat

@onready var player = get_parent()

func set_class_items():
	player_class = Global.player_class

	class_node.set_active(false)

	if player_class == 0:
		class_node = $brawler
		animation = $brawler/skills
		hat = $brawler/hat
		$brawler.visible = true

	elif player_class == 1:
		class_node = $needle
		animation = $needle/skills
		hat = $needle/hat
		$needle.visible = true

	elif player_class == 10:
		# implement later
		class_node = $brawler
		animation = $brawler/skills
		hat = $draco/hat

	class_node.set_active(true)

func get_description():
	return(class_node.get_description())

func attack_1():
	if Input.is_action_pressed("attack 1") and Global.attack1t == 0 and not player.get_attacking():
		class_node.init_attack_1()

func attack_2():
	if Input.is_action_pressed("attack 2") and Global.attack2t == 0 and not player.get_attacking():
		class_node.init_attack_2()

func attack_3():
	if Input.is_action_pressed("attack 3") and Global.attack3t == 0 and not player.get_attacking():
		class_node.init_attack_3()

func attack_4():
	if Input.is_action_pressed("attack 4") and Global.attack4t == 0 and not player.get_attacking():
		class_node.init_attack_4()

func attack_5():
	if Input.is_action_pressed("attack 5") and Global.attack5t == 0 and not player.get_attacking():
		class_node.init_attack_5()

func ultimate():
	if Input.is_action_pressed("ultimate") and Global.ultimatet == 0 and not player.get_attacking():
		class_node.init_ultimate()

func hat_animations():
	var hat_mode = get_parent().get_hat_mode()
	
	hat.speed_scale = (Global.player_spd * 0.035)
	if Global.player_dir == -1:
		hat.flip_h = true
		hat.position.x = 4
	else:
		hat.flip_h = false
		hat.position.x = -4

	if hat_mode == "idle":
		hat.play("hat_idle")
	elif hat_mode == "run":
		hat.play("hat_run")
	elif hat_mode == "jump":
		hat.play("hat_stun")

func _ready() -> void:
	set_class_items()

func _physics_process(_delta: float) -> void:
	hat_animations()
	
	attack_1()
	attack_2()
	attack_3()
	attack_4()
	attack_5()
	ultimate()
