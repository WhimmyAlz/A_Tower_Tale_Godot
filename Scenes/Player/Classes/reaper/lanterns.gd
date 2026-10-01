extends Node2D

var attack_cd = 0

var active = false

func set_active(val):
	active = val

func _physics_process(_delta: float) -> void:
	$Lanterns_node.rotation += 0.01
	
	if active:
		if attack_cd > 0:
			attack_cd -= 1
			if randi_range(1,10) == 1:
				attack_cd = 0
			
		if attack_cd == 0:
			var skull_pick = $Lanterns_node.get_child(randi_range(0,11))
			
			while skull_pick.get_attacking():
				skull_pick = $Lanterns_node.get_child(randi_range(0, 11))
				var all_attacking = true
				for i in range(11):
					if $Lanterns_node.get_child(i).get_attacking() == false:
						all_attacking = false
				if all_attacking == true:
					break
			skull_pick.attack()
			
			attack_cd = 30
			
