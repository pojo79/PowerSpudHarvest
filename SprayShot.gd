extends Area2D


export var MOVE_RATE = 40
export var MAX_RANGE = 30

var moved = 0
var vel = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	moved += MOVE_RATE * delta
	position += (vel * MOVE_RATE) * delta
	if moved > MAX_RANGE:
		queue_free()

func set_vel_and_pos(new_pos, new_vel):
	self.global_position = new_pos
	self.vel = new_vel
	if new_vel.y > 0 or new_vel.y < 0:
		$SprayCloud.rotate(90)

func _on_SprayShot_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_hit()
		queue_free()
	if "MapTile" in area.name:
		queue_free()
