extends RigidBody2D

func _ready():
	set_continuous_collision_detection_mode(2)

func _on_Timer_timeout():
	queue_free()
