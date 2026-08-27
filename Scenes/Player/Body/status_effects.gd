extends Node2D

@onready var player = get_parent()

var berserk = false
var berserk_time = 0

func set_berserk(time):
	if berserk == false:
		Global.bonus_strength += 4
		Global.bonus_agility += 6
		Global.stamina_regen_multi += 1
	berserk = true
	berserk_time = time

func get_berserk():
	return(berserk)

func berserk_effect():
	if berserk:
		berserk_time -= 1
		if berserk_time == 0:
			Global.bonus_strength -= 4
			Global.bonus_agility -= 6
			Global.stamina_regen_multi -= 1
			berserk = false

func _physics_process(_delta: float) -> void:
	berserk_effect()
