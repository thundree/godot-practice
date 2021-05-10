extends TileMap

var grid: Grid
var next_grid: Grid

const TILE_SIZE = 64
export(int) var width
export(int) var height

var selected_type = Particle.TYPES.SAND


func _ready():
	grid = Grid.new(Vector2(width, height))
	
	var width_px = width * TILE_SIZE
	var height_px = height * TILE_SIZE
	
	var cam = $Camera2D
	
	cam.position = Vector2(width_px, height_px) / 2
	cam.zoom = Vector2(width_px, height_px) / Vector2(1920, 1080)
	
	draw()


func _process(delta):
	if Input.is_action_pressed("click"):
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
	grid = new_grid


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
