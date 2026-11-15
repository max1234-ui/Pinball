extends CharacterBody2D

var rest_angle := 55.0
var active_angle := -30.0
var flip_speed := 1200.0
var bounciness := 0.4

var flipping := false

func _physics_process(delta: float) -> void:
	var action
	var flipper_inverse: int = 1
	if scale.x > 0:
		action = "flipper_left"
	else:
		flipper_inverse = -1
		action = "flipper_right"
	var pressed := Input.is_action_pressed(action)
	var target := (active_angle if pressed else rest_angle) * flipper_inverse
	rotation_degrees = move_toward(rotation_degrees, target, flip_speed * delta)
	
	flipping = pressed and not is_equal_approx(rotation_degrees, active_angle*flipper_inverse)
