extends TileMap

signal tile_clicked(target_position)
signal tile_options_requested(target_position)

@export var highlight_layer: int = 1  # Layer for the highlight tile
@export var highlight_atlas_id: int = 0
@export var highlight_tile_coords: Vector2 = Vector2(0, 1)
@export var highlight_tile_id: int = 1
@export var target_layer: int = 2
@export var target_atlas_id: int = 0
@export var target_tile_id: int = 1
var highlighted_cell
var _astar = AStarGrid2D.new()

const NO_CELL = -1
const GRID_WIDTH = 10
const GRID_HEIGHT = 10
const CELL_SIZE = Vector2(16, 16)
@export var game_world_rect: Rect2

func _init():
	_astar.region = Rect2i(0, 0, GRID_WIDTH, GRID_HEIGHT)
	_astar.cell_size = CELL_SIZE
	_astar.update()
	print(_astar.get_id_path(Vector2i(0, 0), Vector2i(3, 4))) # prints (0, 0), (1, 1), (2, 2), (3, 3), (3, 4)
	print(_astar.get_point_path(Vector2i(0, 0), Vector2i(3, 4))) # prints (0, 0), (16, 16), (32, 32), (48, 48), (48, 64)


func _input(event):
	var world_mouse_position = get_global_mouse_position()
	if not game_world_rect.has_point(world_mouse_position):
		if highlighted_cell:
			set_cell(highlight_layer, highlighted_cell, NO_CELL)
			highlighted_cell = null
		return
	var tile_position = local_to_map(world_mouse_position)
	if event is InputEventMouseMotion:
		if highlighted_cell:
			# Clear previous highlight
			set_cell(highlight_layer, highlighted_cell, NO_CELL)
		highlighted_cell = tile_position
		set_cell(highlight_layer, highlighted_cell, highlight_atlas_id, highlight_tile_coords)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("tile_clicked", tile_position)
		print("tile clicked! Position: ", tile_position)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		print("tile right clicked. Position: ", tile_position)
		emit_signal("tile_options_requested", tile_position)


func _on_game_tick():
	print('game ticked')
