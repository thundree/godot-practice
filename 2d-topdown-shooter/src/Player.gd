extends KinematicBody2D

var accel = 1
var move_speed = 500
var bullet_speed = 1000 #2000

var Bullet = preload("res://src/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("up"):
		motion.y -= accel
	if Input.is_action_pressed("down"):
		motion.y += accel
	if Input.is_action_pressed("left"):
		motion.x -= accel
	if Input.is_action_pressed("right"):
		motion.x += accel
	
	motion = motion.normalized()
	motion = move_and_slide(motion * move_speed)
	
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("LMB"):
		open_fire()

func open_fire():
	var bullet = Bullet.instance()
	bullet.position = get_global_position()
	bullet.rotation_degrees = rotation_degrees
	bullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet)
	
func kill():
	get_tree().reload_current_scene()

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		kill()
