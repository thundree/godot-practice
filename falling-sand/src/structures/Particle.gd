class_name Particle
extends Reference

enum TYPES {
	EMPTY,
	SAND,
	WATER,
}


const COLORS = {
	0: '#00000000', # EMPTY
	1: '#c2b280FF', # SAND
	2: '#0f5e9cFF',   # WATER
}


var id: int
var velocity: Vector2
var life_time: float
var has_been_updated: bool

func _init(_id):
	life_time = 0.0
	has_been_updated = false
	velocity = Vector2()

	id = _id
