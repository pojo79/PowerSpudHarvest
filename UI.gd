extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_score():
	$Score_Label.text = "Score : " + str(Globals.score)

func update_lives():
	$Container/Live_Label.text = "X "+str(Globals.lives)
