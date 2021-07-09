extends Reference
class_name StarSystem

var Planet := preload("Planet.gd")

var rng := RandomNumberGenerator.new()

var STAR_COLORS := [
Color("#FFFFFF"),
Color("#D9FFFF"),
Color("#A3FFFF"),
Color("#FFC8C8"),
Color("#FFCB9D"),
Color("#9F9FFF"),
Color("#415EFF"),
Color("#28199D"),
Color("#fd6b3d"),
Color("#a92727")
]

var exists : bool
var diameter : int
var color : Color
var planets : Array
var name : String

func _init(x, y, generate_full_system = false):
	rng.randomize()
	var n_seed = (x & 0xFFFF) << 16 | (y & 0xFFFF)
	rng.set_seed(n_seed)
	name = String(n_seed)
	
	exists = (rng.randi_range(0, 20) == 1)
	
	if not exists: return
	diameter = rng.randf_range(2, 14)
	color = STAR_COLORS[rng.randi_range(0, len(STAR_COLORS) - 1)]
	
	if not generate_full_system: return
	var distance := rng.randi_range(20, 100)
	var n_planets := rng.randi_range(0, 10)
	for n in n_planets:
		var p := Planet.new()
		p.distance = distance
		p.diameter = rng.randf_range(4.0, 20.0)
		p.ring = rng.randi_range(0, 10) == 1
		p.temperature = rng.randf_range(-200.0, 300.0)
		p.foliage = rng.randf_range(0.0, 1.0)
		p.minerals = rng.randf_range(0.0, 1.0)
		p.gases = rng.randf_range(0.0, 1.0)
		p.water = rng.randf_range(0.0, 1.0)
		var sum = 1.0 / (p.foliage + p.minerals + p.gases + p.water)
		p.foliage *= sum
		p.minerals *= sum
		p.gases *= sum
		p.water *= sum
		p.population = max(rng.randi_range(-5000000, 20000000), 0)
		distance += rng.randi_range(20, 200)
		
		var n_moons := max(rng.randi_range(-5, 5), 0)
		for m in n_moons:
			p.moons.append(rng.randf_range(1.0, 5.0))
		planets.append(p)
