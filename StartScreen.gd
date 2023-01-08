extends Node2D

var change_scene = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_key_input(event):
	if change_scene:
		Globals.lives = 3
		Globals.score = 0
		get_tree().change_scene("res://TutorialScreen.tscn")


func _on_Timer_timeout():
	change_scene = true
