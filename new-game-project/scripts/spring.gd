extends StaticBody2D

const LAUNCH_VELOCITY = -1000.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var pressing := false


func _ready() -> void:
	# Play the animation once instead of looping, and rest on the first frame.
	sprite.sprite_frames.set_animation_loop("default", false)
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.stop()
	sprite.frame = 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and not pressing:
		pressing = true
		sprite.play("default")


func _on_animation_finished() -> void:
	# Animation is done: shoot any ball that is waiting in the chute.
	for node in get_parent().get_children():
		if "is_in_chute" in node and node.is_in_chute:
			node.velocity.y = LAUNCH_VELOCITY
	sprite.stop()
	sprite.frame = 0
	pressing = false
