extends Node2D


export var RESPAWN_TIME = 1
export var next_scene = "res://EndScene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.pause_enemies = false
	for potato in get_tree().get_nodes_in_group("potato"):
		potato.connect("harvested", self, "on_harvest")
		potato.connect("eaten", self, "on_eaten")
	
	$Farmer.connect("farmer_die", self, "player_died")
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.connect("enemy_killed", self, "on_enemy_death")

func change_scene():
	$Farmer.queue_free()
	$NextSceneTimer.start(.75)
	Globals.pause_enemies = true
	$EndLevel.play(0)
	yield($NextSceneTimer, "timeout")
	get_tree().change_scene(next_scene)
	
func on_eaten():
	Globals.score -= Globals.potato_score
	$UI.update_score()
	if get_tree().get_nodes_in_group("potato").size() <= 1:
		change_scene()

func on_harvest():
	Globals.score += Globals.potato_score
	$UI.update_score()
	if get_tree().get_nodes_in_group("potato").size() <= 1:
		change_scene()
	
func on_enemy_death():
	Globals.score += Globals.enemy_score
	$UI.update_score()
	if get_tree().get_nodes_in_group("enemy").size() <= 1:
		change_scene()
	
func player_died():
	Globals.pause_enemies = true
	$RespawnTimer.start(RESPAWN_TIME)
	yield($RespawnTimer, "timeout")
	reset_enemies()
	$Farmer.reset($SpawnPoint.global_position)
	Globals.lives -= 1
	if Globals.lives <= 0:
		get_tree().change_scene("res://EndScene.tscn")
	$UI.update_lives()

func reset_enemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.reset()
	Globals.pause_enemies = false
