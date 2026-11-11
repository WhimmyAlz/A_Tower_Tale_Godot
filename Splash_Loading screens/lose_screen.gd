extends Node2D

var death_text = ["Wow. Geeg.", "L + Ratio.", "Live like a fool, die like a fool.", "The end of a tale.", "That's it?"]
var one_shot = 1

func set_animation_pos():
	$AnimatedSprite2D.position = Vector2(int(Global.death_position[0]), int(Global.death_position[1]))

func _ready() -> void:
	$RichTextLabel.text = "[b]%s[/b]" % death_text[randi_range(0, len(death_text)-1)]
	set_animation_pos()

func _physics_process(_delta: float) -> void:
	var travel_val = ($AnimatedSprite2D.position - Vector2(0, 0)).normalized()
	
	if $AnimatedSprite2D.position != Vector2(0, 0):
		$AnimatedSprite2D.position.x -= round(travel_val[0] * 40)
		$AnimatedSprite2D.position.y -= round(travel_val[1] * 40)
	elif one_shot == 1:
		$AnimatedSprite2D.play()
		one_shot = 0
	
	if abs($AnimatedSprite2D.position.x) < 20:
		$AnimatedSprite2D.position.x = 0
	elif abs($AnimatedSprite2D.position.x) < 40:
		$AnimatedSprite2D.position.x = 15
	if abs($AnimatedSprite2D.position.y) < 20:
		$AnimatedSprite2D.position.y = 0
	elif abs($AnimatedSprite2D.position.y) < 40:
		$AnimatedSprite2D.position.y = 15


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.frame == 5:
		$RichTextLabel.visible = true
		$AnimatedSprite2D/CPUParticles2D.emitting = true
		$TextureButton.visible = true


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Splash_Loading screens/Splash_screen.tscn")
