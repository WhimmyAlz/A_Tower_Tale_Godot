extends Node2D

var entered
var offset
var scale_offset

func move():
	if entered and Input.is_action_just_pressed("left_click"):
		offset = position - get_global_mouse_position()
	if entered and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		position = get_global_mouse_position() + offset
	
	if entered and Input.is_action_just_pressed("right_click"):
		scale_offset = 200 - get_global_mouse_position()[0]
	if entered and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		scale.x = 0.005 * (get_global_mouse_position()[0] + scale_offset)
		scale.y = 0.005 * (get_global_mouse_position()[0] + scale_offset)

func _physics_process(_delta: float) -> void:
	move()

func _on_drag_collider_mouse_entered() -> void:
	entered = true

func _on_drag_collider_mouse_exited() -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		entered = false
