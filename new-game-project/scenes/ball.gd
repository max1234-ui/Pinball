extends CharacterBody2D

var is_in_chute = false
var in_game = false
var dead = false

func _on_body_entered(body: Node2D) -> void:
	if "is_in_chute" in body:
		body.is_in_chute = true

func _on_body_exited(body: Node2D) -> void:
	if "is_in_chute" in body:
		body.is_in_chute = false


const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
var speed = 1


func _physics_process(delta: float) -> void:
	# Add the gravity.
		# TEMP: left/right control (arrow keys / A-D mapped to ui_left / ui_right)
	if in_game:
		velocity.x += Input.get_axis("ui_left", "ui_right") * 600.0 * delta
	velocity += get_gravity() * delta


	var collision = move_and_collide(velocity * delta)
	if collision:
		print(collision.get_collider().name)
		velocity = velocity.bounce(collision.get_normal()) * 0.8
