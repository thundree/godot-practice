extends TileMap

var grid: Grid
var next_grid: Grid

const TILE_SIZE = 64
export(int) var width
export(int) var height

var selected_type = Particle.TYPES.SAND
var spawn_blocks: = false

func _ready():
	grid = Grid.new(Vector2(width, height))
	
	var width_px = width * TILE_SIZE
	var height_px = height * TILE_SIZE
	
	var cam = $Camera2D
	
	cam.position = Vector2(width_px, height_px) / 2
	cam.zoom = Vector2(width_px, height_px) / Vector2(1920, 1080)
	
	draw()


func _process(delta):
	spawn_blocks = false
	if Input.is_action_pressed("mouse_left"):
		selected_type = Particle.TYPES.SAND
		spawn_blocks = true
	elif Input.is_action_pressed("mouse_right"):
		selected_type = Particle.TYPES.WATER
		spawn_blocks = true

	if spawn_blocks:
		var pos = (get_local_mouse_position() / TILE_SIZE).floor()
		spawn_particle(pos)

	draw()
	update()


func draw():
	var p: Particle
	for x in range(width):
		for y in range(height):
			p = grid.get_cell(x, y)
			set_cell(x, y, p.id if p else 0) 


func spawn_particle(pos):
	grid.set_cellv(pos, Particle.new(selected_type))
	set_cellv(pos, selected_type)


func update():
	var p: Particle
	var id: int
	
	var new_grid: Grid = Grid.new(Vector2(width, height))
	
	for x in range(width):
		for y in range(height):
			p = grid.get_cell(x, y)
			id = p.id if p else 0
			
			match id:
				Particle.TYPES.EMPTY:
					pass

				Particle.TYPES.SAND:
					new_grid.set_cellv(update_sand(x, y), p)

				Particle.TYPES.WATER:
					new_grid.set_cellv(update_water(x, y), p)

	grid = new_grid


func update_water(x: int, y: int) -> Vector2:
	var down = grid.get_cell(x, y + 1)
	
	# CASE 0: MAP LIMIT
	if typeof(down) == TYPE_INT:
		return Vector2(x, y)

	# CASE 1: Move down
	if not down:
		return Vector2(x, y + 1)

	var dleft = grid.get_cell(x - 1, y + 1)
	var dright = grid.get_cell(x + 1, y + 1)

	# CASE 2: Move diagonal left
	if not down and not dleft:
		return Vector2(x - 1, y + 1)
	# CASE 3: Move diagonal right
	if not down and not dright:
		return Vector2(x + 1, y + 1)

	var left = grid.get_cell(x - 2, y + 1)
	var right = grid.get_cell(x + 2, y + 1)

	if down and not left:
		return Vector2(x - 1, y)

	if down and not right:
		return Vector2(x + 1, y)

	# CASE DEFAULT
	return Vector2(x, y)

func update_sand(x: int, y: int) -> Vector2:
	var down = grid.get_cell(x, y + 1)
	
	# CASE 0: MAP LIMIT
	if typeof(down) == TYPE_INT:
		return Vector2(x, y)
	
	# CASE 1: Move down
	if not down:
		return Vector2(x, y + 1)
	
	var left = grid.get_cell(x - 1, y + 1)
	var right = grid.get_cell(x + 1, y + 1)
	
	# CASE 2: Move diagonal left
	if down and not left:
		return Vector2(x - 1, y + 1)

	# CASE 3: Move diagonal right
	if down and not right:
		return Vector2(x + 1, y + 1)
	
	# CASE DEFAULT
	return Vector2(x, y)
