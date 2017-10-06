extends Node2D

export var gridSize = Vector2()
export (TileSet) var tileset

const BASE_TILE_MAP = 0
const SOLID_TILE_MAP = 1

var grid_start_x
var grid_start_y
var grid_end_x
var grid_end_y
var tile_maps

func _ready():
	
	grid_start_x = 0
	grid_start_y = 0
	grid_end_x = int(gridSize.x)
	grid_end_y = int(gridSize.y)
	
	tile_maps = self.get_children()
	
	var basemap = tile_maps[BASE_TILE_MAP]
	var solidmap = tile_maps[SOLID_TILE_MAP]
	
	
	var water = tileset.find_tile_by_name("WaterGrass_00")
	var grass = tileset.find_tile_by_name("Grass_01")
	var tree = tileset.find_tile_by_name("Tree_00")
	var empty = -1
	
	print (water, grass, tree, empty)
	
	basic_perlin_fill(tile_maps, grass, water, tree)
	
	# Index tileset groups
	
	var water_grass = []
	for i in range(16):
		water_grass.append(tileset.find_tile_by_name("WaterGrass_%02d" % i))

	var tree_edge = []
	for i in range(16):
		tree_edge.append(tileset.find_tile_by_name("Tree_%02d" % i))
	
	var grasses = []
	for i in range(1, 9):
		grasses.append(tileset.find_tile_by_name("Grass_%02d" % i))
	
	simple_marching_squares(basemap, water, grass, water_grass)
	
	simple_marching_squares(solidmap, tree, empty, tree_edge, true)
	
	randomise_grass(basemap, grass, grasses)

func basic_perlin_fill(tile_maps, grass, water, tree):
	
	var basemap = tile_maps[BASE_TILE_MAP]
	var solidmap = tile_maps[SOLID_TILE_MAP]
	
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

func simple_marching_squares(tile_map, fill_tile, opposing, fill_group, internal = false):
	if internal and not fill_group.has(fill_tile):
		fill_group.append(fill_tile)
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if fill_tile == tile_map.get_cell(x, y):
				var score = 0
				if internal:
					score = get_internal_corner_score(tile_map, x, y, fill_group)
				else:
					score = get_corner_score(tile_map, x, y, opposing) 
				tile_map.set_cell(x, y, fill_group[score])

func get_corner_score(tile_map, x, y, opposing):
	var score = 0
	
	var tp = tile_map.get_cell(x, y - 1) == opposing
	var bm = tile_map.get_cell(x, y + 1) == opposing
	var lt = tile_map.get_cell(x - 1, y) == opposing
	var rt = tile_map.get_cell(x + 1, y) == opposing
	var br = tile_map.get_cell(x + 1, y + 1) == opposing
	var bl = tile_map.get_cell(x - 1, y + 1) == opposing
	var tr = tile_map.get_cell(x + 1, y - 1) == opposing
	var tl = tile_map.get_cell(x - 1, y - 1) == opposing
	
	if br or rt or bm:
		score += 1
	
	if bl or lt or bm:
		score += 2
	
	if tr or rt or tp:
		score += 4
	
	if tl or lt or tp:
		score += 8
	
	return score
	
func get_internal_corner_score(tile_map, x, y, fill_group):
	var score = 0
	
	var tp = 1 if not fill_group.has(tile_map.get_cell(x,     y - 1)) else 0
	var bm = 1 if not fill_group.has(tile_map.get_cell(x,     y + 1)) else 0
	var lt = 1 if not fill_group.has(tile_map.get_cell(x - 1, y    )) else 0
	var rt = 1 if not fill_group.has(tile_map.get_cell(x + 1, y    )) else 0
	var br = 1 if not fill_group.has(tile_map.get_cell(x + 1, y + 1)) else 0
	var bl = 1 if not fill_group.has(tile_map.get_cell(x - 1, y + 1)) else 0
	var tr = 1 if not fill_group.has(tile_map.get_cell(x + 1, y - 1)) else 0
	var tl = 1 if not fill_group.has(tile_map.get_cell(x - 1, y - 1)) else 0
	
	if (br + rt + bm) >= 1:
		score += 1
	
	if (bl + lt + bm) >= 1:
		score += 2
	
	if (tr + rt + tp) >= 1:
		score += 4
	
	if (tl + lt + tp) >= 1:
		score += 8
	
	return score

func randomise_grass(tile_map, grass, grasses):
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if grass == tile_map.get_cell(x, y):
				tile_map.set_cell(x, y, grasses[rand_range(0,8)])