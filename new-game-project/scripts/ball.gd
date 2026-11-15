extends CharacterBody2D
@onready var bumper_sound: AudioStreamPlayer2D = $BumperSound



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
const DEFAULT_BOUNCINESS = 0.0
var speed = 1


func _physics_process(delta: float) -> void:
	# TEMP
	if in_game:
		velocity.x += Input.get_axis("ui_left", "ui_right") * 600.0 * delta
	velocity += get_gravity() * delta

	# bouncing
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		var bounce = DEFAULT_BOUNCINESS

		if collider is TileMapLayer:
			var tile_pos = collider.get_coords_for_body_rid(collision.get_collider_rid())
			var data = collider.get_cell_tile_data(tile_pos)
			if data:
				bounce = data.get_custom_data("bounciness")
				if bounce > 0:
					bumper_sound.play()

		velocity = velocity.bounce(collision.get_normal()) * bounce
