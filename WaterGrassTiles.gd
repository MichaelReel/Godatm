extends Node2D

export var gridSize = Vector2()
export (TileSet) var tileset

const BASE_TILE_MAP = 0
const SOLID_TILE_MAP = 1

var grid_start_x
var grid_start_y
var grid_end_x
var grid_end_y
var tilemaps

func _ready():
	
	grid_start_x = 0
	grid_start_y = 0
	grid_end_x = int(gridSize.x)
	grid_end_y = int(gridSize.y)
	
	tilemaps = self.get_children()
	
	var basemap = tilemaps[BASE_TILE_MAP]
	var solidmap = tilemaps[SOLID_TILE_MAP]
	
	var water = tileset.find_tile_by_name("WaterGrass_00")
	var grass = tileset.find_tile_by_name("Grass_01")
	var tree = tileset.find_tile_by_name("Tree_00")
	
	basic_perlin_fill(tilemaps, grass, water, tree)
	
	# Index tileset groups
	
	var waterGrass = []
	for i in range(16):
		waterGrass.append(tileset.find_tile_by_name("WaterGrass_%02d" % i))

	var tree = []
	for i in range(16):
		waterGrass.append(tileset.find_tile_by_name("Tree_%02d" % i))
	
	var grasses = []
	for i in range(1, 9):
		grasses.append(tileset.find_tile_by_name("Grass_%02d" % i))
	
	simple_marching_squares(basemap, grass, waterGrass)
	
	randomise_grass(basemap, grass, grasses)

func basic_perlin_fill(tilemaps, grass, water, tree):
	
	var basemap = tilemaps[BASE_TILE_MAP]
	var solidmap = tilemaps[SOLID_TILE_MAP]
	
	var perlinRef = load("res://PerlinRef.gd")
	var base = perlinRef.new(64, 64, 10)
	var solid = perlinRef.new(64, 64, 5)
	
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if base.getHash(x, y) >= 0.05:
				basemap.set_cell(x, y, water)
			else:
				basemap.set_cell(x, y, grass)
				if solid.getHash(x, y) >= 0.05:
					solidmap.set_cell(x, y, tree)

func simple_marching_squares(tilemap, grass, waterGrass):
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if grass != tilemap.get_cell(x, y):
				tilemap.set_cell(x, y, waterGrass[get_corner_score(tilemap, x, y, grass)])

func get_corner_score(tilemap, x, y, grass):
	var score = 0
	
	var top = tilemap.get_cell(x, y - 1) == grass
	var bottom = tilemap.get_cell(x, y + 1) == grass
	var left = tilemap.get_cell(x - 1, y) == grass
	var right = tilemap.get_cell(x + 1, y) == grass
	var br = tilemap.get_cell(x + 1, y + 1) == grass
	var bl = tilemap.get_cell(x - 1, y + 1) == grass
	var tr = tilemap.get_cell(x + 1, y - 1) == grass
	var tl = tilemap.get_cell(x - 1, y - 1) == grass
	
	if br or right or bottom:
		score += 1
	
	if bl or left or bottom:
		score += 2
	
	if tr or right or top:
		score += 4
	
	if tl or left or top:
		score += 8
	
	return score

func randomise_grass(tilemap, grass, grasses):
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if grass == tilemap.get_cell(x, y):
				tilemap.set_cell(x, y, grasses[rand_range(0,8)])

