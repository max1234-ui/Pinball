extends CanvasLayer

@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	# static vars survive scene reloads (R key), so reset here
	Gwendal.score = 0
	_update_label()

	var gwendal := get_parent().get_node("gwendal") as Gwendal
	gwendal.ball_eaten.connect(_on_ball_eaten)


func _on_ball_eaten(_points: int) -> void:
	_update_label()


func _update_label() -> void:
	score_label.text = "Score: %d" % Gwendal.score
