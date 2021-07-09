extends ColorRect

var StarSystem := preload("structures/StarSystem.gd")

var star : StarSystem

func _ready():
	hide()

func hide():
	visible = false

func display_info(star):
	visible = true
	self.star = star
	update()
	
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func _draw():
	var m_distance
	draw_circle(Vector2(140, 180), 130, star.color)
	var distance = 230
	for p in star.planets:
		distance += 70 * 1.4
		draw_circle(Vector2(p.diameter + distance, 180), p.diameter * 2, Color.orangered)
		if p.ring:
			draw_circle_arc(
				Vector2(p.diameter + distance, 180),
				p.diameter * 2 + 3,
				0,
				360,
				Color.brown
			)
		draw_string(
			Label.new().get_font(""),
			Vector2(p.diameter + distance - 30, 140),
			("F: %0.2f" % (p.foliage * 100)) + "%"
		)
		draw_string(
			Label.new().get_font(""),
			Vector2(p.diameter + distance - 30, 120),
			("M: %0.2f" % (p.minerals * 100)) + "%"
		)
		draw_string(
			Label.new().get_font(""),
			Vector2(p.diameter + distance - 30, 100),
			("W: %0.2f" % (p.water * 100)) + "%"
		)
		draw_string(
			Label.new().get_font(""),
			Vector2(p.diameter + distance - 30, 80),
			("G: %0.2f" % (p.gases * 100)) + "%"
		)
		draw_string(
			Label.new().get_font(""),
			Vector2(p.diameter + distance - 30, 60),
			("T: %0.2f" % (p.temperature)) + "°C"
		)
		draw_string(
			Label.new().get_font(""),
			Vector2(p.diameter + distance - 30, 40),
			"P: %d" % (p.population)
		)

		m_distance = p.diameter
		for m in p.moons:
			m_distance += 25
			draw_circle(Vector2(p.diameter + distance, 180 + m_distance), m * 1.5, Color.aliceblue)
