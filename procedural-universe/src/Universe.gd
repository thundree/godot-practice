extends Node2D

var StarSystem := preload("structures/StarSystem.gd")
onready var panel = $Panel

export var SPEED := 50

export var SECTOR_SIZE := 32 # Higher numbers = Sparser stars
var CENTER_OFFSET = floor(SECTOR_SIZE / 2)
var X_SECTORS : int
var Y_SECTORS : int

var galaxy_offset := Vector2(0, 0)
var click : bool

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func _ready():
	X_SECTORS = floor(get_viewport().size.x / SECTOR_SIZE)
	Y_SECTORS = floor(get_viewport().size.y / SECTOR_SIZE)

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		galaxy_offset.y -= SPEED * delta
		update()
	if Input.is_action_pressed("ui_down"):
		galaxy_offset.y += SPEED * delta
		update()
	if Input.is_action_pressed("ui_left"):
		galaxy_offset.x -= SPEED * delta
		update()
	if Input.is_action_pressed("ui_right"): 
		galaxy_offset.x += SPEED * delta
		update()
	if Input.is_action_pressed("ui_end"):
		panel.hide()
		
func _input(event):
	if event is InputEventMouseMotion:
		update()

func _draw():
	var star : StarSystem
	var new_x : int
	var new_y : int
	
	for x in X_SECTORS:
		for y in Y_SECTORS:
			new_x = x + floor(galaxy_offset.x)
			new_y = y + floor(galaxy_offset.y)
			
			star = StarSystem.new(new_x, new_y)
			if star.exists:
				draw_circle(Vector2(x * SECTOR_SIZE + 16, y * SECTOR_SIZE + 16), star.diameter, star.color)
				
				var mouse = (get_global_mouse_position() / SECTOR_SIZE).floor()
				var galaxy_mouse = (mouse + galaxy_offset).floor()
				if galaxy_mouse.x == new_x and galaxy_mouse.y == new_y:
					draw_circle_arc(
						Vector2(
							x * SECTOR_SIZE + CENTER_OFFSET,
							y * SECTOR_SIZE + CENTER_OFFSET
						),
						star.diameter + 5, # Radius
						0, # From angle
						360, # To angle
						Color.yellow # Color
					)
					draw_string(
						Label.new().get_font(""),
						Vector2(
							x * SECTOR_SIZE + CENTER_OFFSET,
							y * SECTOR_SIZE + CENTER_OFFSET - 20
						),
						star.name
					)
	
	var is_star_selected := false
	var selected_star := Vector2(0, 0).floor()
	if Input.is_action_pressed("ui_click"):
		var mouse = (get_global_mouse_position() / SECTOR_SIZE).floor()
		var galaxy_mouse = (mouse + galaxy_offset).floor()
		star = StarSystem.new(int(galaxy_mouse.x), int(galaxy_mouse.y))
		if star.exists:
			is_star_selected = true
			selected_star = Vector2(galaxy_mouse.x, galaxy_mouse.y)
		else:
			is_star_selected = false
			
	if is_star_selected:
		star = StarSystem.new(int(selected_star.x), int(selected_star.y), true)
		panel.display_info(star)
