extends Area2D

const BALL_SCENE = preload("res://scenes/ball.tscn")

@export var balls := 3

var spawn_position: Vector2


func _ready() -> void:
	# The ball that already sits in the level defines where new balls spawn.
	spawn_position = get_parent().get_node("CharacterBody2D").position


func _on_body_entered(body: Node2D) -> void:
	if "dead" in body:
		body.dead = true
		body.queue_free()
		balls -= 1
		print("Balls left: ", balls)
		if balls > 0:
			call_deferred("_spawn_ball")
			
func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed and not event.echo and event.keycode == KEY_R:
		get_tree().reload_current_scene()

func _spawn_ball() -> void:
	var level = get_parent()
	var ball = BALL_SCENE.instantiate()
	ball.position = spawn_position
	level.add_child(ball)
	var chute = level.get_node("Area2D")
	chute.body_entered.connect(ball._on_body_entered)
	chute.body_exited.connect(ball._on_body_exited)
