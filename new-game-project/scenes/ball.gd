extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_in_chute = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_in_chute:
		pass

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_in_chute():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.is_in_chute = true




func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
