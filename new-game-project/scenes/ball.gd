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
var speed = 1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_in_chute and not in_game:
		velocity.y = JUMP_VELOCITY
		in_game = true


	var collision = move_and_collide(velocity * delta)
	if collision:
		print(collision.get_collider().name)
		#var tilemap = get_parent().find_child("TileMapLayer", true) as TileMapLayer
		#var tilePos = tilemap.local_to_map(collision.get_collider())
		#var data = tilemap.get_cell_tile_data(tilePos)
		velocity = velocity.bounce(collision.get_normal()) * 0.8
