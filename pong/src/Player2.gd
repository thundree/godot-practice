extends KinematicBody2D

var speed = Vector2()
var score = 0

func has_won():
	return (score >= 3)

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		speed.y = -350
	elif Input.is_action_pressed("ui_down"):
		speed.y = 350
	else:
		speed.y = 0
		
	speed = move_and_slide(speed)
