extends Node2D

@onready var skill_1 = $bar_1/bar_1_prog
@onready var skill_2 = $bar_2/bar_2_prog
@onready var skill_3 = $bar_3/bar_3_prog
@onready var skill_4 = $bar_4/bar_4_prog
@onready var skill_5 = $bar_5/bar_5_prog

func update_prog():
	skill_1.value = Global.attack1t
	skill_1.max_value = Global.attack1_max_t
	
	skill_2.value = Global.attack2t
	skill_2.max_value = Global.attack2_max_t
	
	skill_3.value = Global.attack3t
	skill_3.max_value = Global.attack3_max_t
	
	skill_4.value = Global.attack4t
	skill_4.max_value = Global.attack4_max_t
	
	skill_5.value = Global.attack5t
	skill_5.max_value = Global.attack5_max_t

func _physics_process(_delta: float) -> void:
	update_prog()
