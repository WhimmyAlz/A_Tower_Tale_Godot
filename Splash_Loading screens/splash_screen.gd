extends Node2D

var difficulty_list = ["easy", "normal"]
var difficulty_increment = 1

func _on_start_button_pressed() -> void:
	Global.reset_stats()
	Global._ready()
	get_tree().change_scene_to_file("res://Scenes/Settings/Floor/Base_floor.tscn")


func _on_texture_button_pressed() -> void:
	$gore_warning.visible = false
	Global.gore = true

func _on_texture_button_2_pressed() -> void:
	$gore_warning.visible = false
	Global.gore = false

func _ready() -> void:
	if Global.gore == null:
		$gore_warning.visible = true


func _on_right_pressed() -> void:
	difficulty_increment += 1
	
	Global.difficulty = difficulty_list[difficulty_increment]
	$Buttons/difficulty/RichTextLabel.text = "[b]%s" % difficulty_list[difficulty_increment].capitalize()
	
	$Buttons/difficulty/left.visible = true
	if difficulty_increment == len(difficulty_list)-1:
		$Buttons/difficulty/right.visible = false

func _on_left_pressed() -> void:
	difficulty_increment -= 1
	
	Global.difficulty = difficulty_list[difficulty_increment]
	$Buttons/difficulty/RichTextLabel.text = "[b]%s" % difficulty_list[difficulty_increment].capitalize()
	
	$Buttons/difficulty/right.visible = true
	if difficulty_increment == 0:
		$Buttons/difficulty/left.visible = false
