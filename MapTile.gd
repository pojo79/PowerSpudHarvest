extends Area2D


func _ready():
	self.set_self_modulate(Color.saddlebrown)


func _on_MapTile_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
	if area.is_in_group("enemy"):
		if not area.phased_out:
			queue_free()
