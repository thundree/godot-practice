extends KinematicBody2D

var speed
var velocity
var collision

func init():
	# Self prop ssets
	position = Vector2(960, 536)
	speed = 450
	velocity = Vector2()
	randomize()
	velocity.x = [-1, 1][randi() % 2]
	velocity.y = [-0.8, 0.8][randi() % 2]
	
	# Timer
	#$Timer

func _process(delta):
	collision = move_and_collide(velocity * speed * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
