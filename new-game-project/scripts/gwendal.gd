class_name Gwendal
extends StaticBody2D

signal ball_eaten(points: int)

static var score := 0

const POINTS := 100
const MOUTH_OPEN_FRAME := 1
const CHEW_TIME := 1.5        # seconds before the ball comes back

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var munch_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	sprite.stop()
	sprite.frame = 0


func hit() -> bool:
	var count := sprite.sprite_frames.get_frame_count(sprite.animation)
	sprite.frame = wrapi(sprite.frame + 1, 0, count)
	if sprite.frame != MOUTH_OPEN_FRAME:
		return false
	scale = Vector2(0.2, 0.2)
	rotation_degrees = randi_range(-60, 30)
	munch_sound.play()
	score += POINTS
	ball_eaten.emit(POINTS)
	print("Score: ", score)
	get_tree().create_timer(CHEW_TIME).timeout.connect(_close_mouth)
	scale = Vector2(0.15, 0.15)
	return true


func _close_mouth() -> void:
	sprite.frame = 0
