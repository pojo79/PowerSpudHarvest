extends Area2D


export var FALL_RATE = 60
export var POTATO_PADDING = 4
var fall = false
var planted = true

signal harvested
signal eaten
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for area in get_overlapping_areas():
		if "MapTile" in area.name and area.global_position.y > self.global_position.y + POTATO_PADDING:
			fall = false
			break
		else:
			fall = true
			$FallTimer.start()
	
	if fall:
		position.y += FALL_RATE * delta
		
func _on_Potato_area_entered(area):
	if area.is_in_group("enemy"):
		emit_signal("eaten")
		queue_free()
	if area.name == "Farmer":
			emit_signal("harvested")
			queue_free()

func _on_FallTimer_timeout():
	planted = false
