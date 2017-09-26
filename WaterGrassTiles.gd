extends TileMap

export var gridSize = Vector2()

var grid_start_x;
var grid_start_y;
var grid_end_x;
var grid_end_y;

func _ready():
	
	grid_start_x = 0
	grid_start_y = 0
	grid_end_x = int(gridSize.x)
	grid_end_y = int(gridSize.y)
	
	var tilemap = self
	var tileset = tilemap.get_tileset()
	var water = tileset.find_tile_by_name("WaterGrass_00")
	var grass = tileset.find_tile_by_name("Grass_01")
	
	basic_perlin_fill(tilemap, grass, water)
	
	var waterGrass = []
	for i in range(16):
		waterGrass.append(tileset.find_tile_by_name("WaterGrass_%02d" % i))
	
	simple_marching_squares(tilemap, grass, waterGrass)
	
	var grasses = []
	for i in range(1, 9):
		grasses.append(tileset.find_tile_by_name("Grass_%02d" % i))
	
	randomise_grass(tilemap, grass, grasses)

func basic_perlin_fill(tilemap, grass, water):
	
	var perlin = load("res://PerlinRef.gd").new(64, 64, 10)
	
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if perlin.getHash(x, y) >= 0.05:
				tilemap.set_cell(x, y, water)
			else:
				tilemap.set_cell(x, y, grass)

func simple_marching_squares(tilemap, grass, waterGrass):
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if grass != tilemap.get_cell(x, y):
				tilemap.set_cell(x, y, waterGrass[get_corner_score(tilemap, x, y, grass)])

func get_corner_score(tilemap, x, y, grass):
	var score = 0
	
	var cell = tilemap.get_cell(x + 1, y + 1)
	if cell == grass:
		score += 1
	
	cell = tilemap.get_cell(x - 1, y + 1)
	if cell == grass:
		score += 2
	
	cell = tilemap.get_cell(x + 1, y - 1)
	if cell == grass:
		score += 4
	
	cell = tilemap.get_cell(x - 1, y - 1)
	if cell == grass:
		score += 8
	
	return score

func randomise_grass(tilemap, grass, grasses):
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if grass == tilemap.get_cell(x, y):
				tilemap.set_cell(x, y, grasses[rand_range(0,8)])


