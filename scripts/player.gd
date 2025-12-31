extends CharacterBody2D

var speed = 50

var clicked_position: Vector2
var target_position: Vector2

func _ready() -> void:
	clicked_position = position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		clicked_position = get_global_mouse_position()
	
	if position.distance_to(clicked_position) > 3:
		target_position = (clicked_position - position).normalized()
		velocity = target_position * speed
		move_and_slide()
