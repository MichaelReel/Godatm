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
	
	var edgeTool = load("res://MarchingSquares.gd").new(grid_end_x, grid_end_y)
	
	# Index tileset groups
	var water_sand = []
	for i in range(16):
		water_sand.append(tileset.find_tile_by_name("WaterSand_%02d" % i))
	
	var water_grass = []
	for i in range(16):
		water_grass.append(tileset.find_tile_by_name("WaterGrass_%02d" % i))
	
	var sand_grass = []
	for i in range(16):
		sand_grass.append(tileset.find_tile_by_name("SandGrass_%02d" % i))

	var tree_edge = []
	for i in range(16):
		tree_edge.append(tileset.find_tile_by_name("Tree_%02d" % i))
	
	var grasses = []
	for i in range(1, 9):
		grasses.append(tileset.find_tile_by_name("Grass_%02d" % i))
	
	# Select primary file tiles
	var water = water_grass[0]
	var sand = sand_grass[0]
	var grass = grasses[0]
	var tree = tree_edge[0]
	var empty = -1
	
	print (water, grass, tree, empty)
	
	basic_perlin_fill(tile_maps, grass, water, tree)
	
	edgeTool.simple_marching_squares(basemap, water_grass, grasses)
	
	edgeTool.simple_marching_squares(solidmap, tree_edge, [empty], true)
	
	randomise_grass(basemap, grass, grasses)

func basic_perlin_fill(tile_maps, grass, water, tree):
	
	var basemap = tile_maps[BASE_TILE_MAP]
	var solidmap = tile_maps[SOLID_TILE_MAP]
	
	var perlinRef = load("res://PerlinRef.gd")
	var base = perlinRef.new(64, 64, 10)
	var solid = perlinRef.new(64, 64, 5)
	
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if base.getAggregateHash(x, y, 3) >= 0.05:
				basemap.set_cell(x, y, water)
			else:
				basemap.set_cell(x, y, grass)
				if solid.getHash(x, y) >= 0.05:
					solidmap.set_cell(x, y, tree)

func randomise_grass(tile_map, grass, grasses):
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if grass == tile_map.get_cell(x, y):
				tile_map.set_cell(x, y, grasses[rand_range(0,8)])