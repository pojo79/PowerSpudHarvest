extends Node2D


var allow_continue = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$PotatoScreen/Score_Label.text = str(Globals.score)
	
	
func _unhandled_key_input(event):
	if allow_continue:
		get_tree().change_scene("res://StartScreen.tscn")


func _on_Timer_timeout():
	allow_continue = true
