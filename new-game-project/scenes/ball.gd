extends CharacterBody2D

var is_in_chute = false
var in_game = false

func _on_body_entered(body: Node2D) -> void:
	if "is_in_chute" in body:
		body.is_in_chute = true

func _on_body_exited(body: Node2D) -> void:
	if "is_in_chute" in body:
		body.is_in_chute = false

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_in_chute and not in_game:
		velocity.y = JUMP_VELOCITY
		in_game = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
