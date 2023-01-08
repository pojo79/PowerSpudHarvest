extends Node2D

var change_scene = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_key_input(event):
	if change_scene:
		get_tree().change_scene("res://Levels/Level1.tscn")


func _on_Timer_timeout():
	change_scene = true
