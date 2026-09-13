extends Node2D

@onready var player = get_parent().get_parent().get_body()

var preload_status_box = preload("res://Scenes/Player/Player_UI/Status_effects/status_effect_box.tscn")
var status_box

var berserk = false
var berserk_time = 0

func init_status_box(status, status_level, time):
	status_box = preload_status_box.instantiate()
	status_box.set_status(status)
	status_box.set_status_level(status_level)
	status_box.set_time(time)
	status_box.set_color(Color.RED)
	$FlowContainer.add_child(status_box)

func update_status_box(status, status_level, time):
	for i in range(self.get_child(0).get_child_count()):
		var effect = self.get_child(0).get_child(i-1)
		if effect.get_status() == status:
			effect.set_status_level(status_level)
			effect.set_time(time)

func set_berserk(time):
	if berserk == false:
		init_status_box("Berserk", 1, time)
		Global.bonus_strength += 10
		Global.bonus_agility += 15
		Global.stamina_regen_multi += 1
	else:
		update_status_box("Berserk", 1, time)
	berserk = true
	berserk_time = time

func get_berserk():
	return(berserk)

func berserk_effect():
	if berserk:
		berserk_time -= 1
		if berserk_time == 0:
			Global.bonus_strength -= 10
			Global.bonus_agility -= 15
			Global.stamina_regen_multi -= 1
			berserk = false

func _physics_process(_delta: float) -> void:
	berserk_effect()
