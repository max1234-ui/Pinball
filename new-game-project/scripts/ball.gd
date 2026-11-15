extends CharacterBody2D

@onready var bumper_sound: AudioStreamPlayer2D = $BumperSound

const DEFAULT_BOUNCINESS := 0.0
const BUMPER_THRESHOLD := 1.0
const SOUND_MIN_SPEED := 150.0
const GWENDAL_BOUNCINESS := 0.8
const SPIT_OFFSET := 12.0

var is_in_chute := false
var in_game := false
var dead := false


func _on_body_entered(body: Node2D) -> void:
	if "is_in_chute" in body:
		body.is_in_chute = true


func _on_body_exited(body: Node2D) -> void:
	if "is_in_chute" in body:
		body.is_in_chute = false


func _physics_process(delta: float) -> void:
	# TEMP: replace with flippers
	if in_game:
		velocity.x += Input.get_axis("ui_left", "ui_right") * 600.0 * delta
	velocity += get_gravity() * delta

	var collision := move_and_collide(velocity * delta)
	if not collision:
		return

	var normal := collision.get_normal()
	var collider := collision.get_collider()
	var bounce := DEFAULT_BOUNCINESS

	if collider is TileMapLayer:
		var tile_pos: Vector2i = collider.get_coords_for_body_rid(collision.get_collider_rid())
		var data: TileData = collider.get_cell_tile_data(tile_pos)
		if data:
			var value = data.get_custom_data("bounciness")
			if value != null:
				bounce = value
	elif collider is Gwendal:
		if collider.hit():
			_get_eaten(normal)
			return
		bounce = GWENDAL_BOUNCINESS

	if bounce > 0.0:
		if bounce > BUMPER_THRESHOLD and velocity.length() > SOUND_MIN_SPEED:
			bumper_sound.play()
		velocity = velocity.bounce(normal) * bounce
	else:
		velocity = velocity.slide(normal)


func _get_eaten(normal: Vector2) -> void:
	var spit_pos := global_position + normal * SPIT_OFFSET
	var spit_velocity := velocity.bounce(normal) * GWENDAL_BOUNCINESS

	# vanish: no physics, no collision, invisible
	set_physics_process(false)
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

	await get_tree().create_timer(Gwendal.CHEW_TIME).timeout

	# come back from where it touched gwendal
	global_position = spit_pos
	velocity = spit_velocity
	$CollisionShape2D.set_deferred("disabled", false)
	show()
	set_physics_process(true)
