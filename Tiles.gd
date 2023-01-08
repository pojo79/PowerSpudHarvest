extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_tile_at_position(pos):
	var local_pos = to_local(pos)
	var cell_position = world_to_map(local_pos)
	set_cell(cell_position.x, cell_position.y, 1)
