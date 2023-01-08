extends Area2D


export var health = 3
export var MAX_TRAVEL = 60
export var MOVE_SPEED = 10
export var THINK_TIME = 20
export var PERSUE_TIME = 5

var travelled = 0
var phased_out = false
var dir = Vector2.ZERO
var rand = RandomNumberGenerator.new()
onready var spawn_point = global_position

onready var window_size = get_viewport_rect().size

signal enemy_killed
# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()
	dir = get_random_direction()
	$AITimer.start(THINK_TIME)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.pause_enemies:
		return
	if dir.x > 0:
		$Enemy.flip_h = true
	else:
		$Enemy.flip_h = false
	var speed = MOVE_SPEED
	if phased_out:
		speed = MOVE_SPEED * 1.5
	travelled += speed * delta
	position += (dir * speed) * delta
	if (travelled > MAX_TRAVEL and not phased_out) or out_of_view():
		dir = dir * -1
		travelled = 0

func reset():
	global_position = spawn_point
	get_random_direction()
		
func out_of_view():
	if position.x < 0 or position.x > window_size.x:
		return true
	if position.y < 32 or position.y > window_size.y:
		return true
	return false

func get_random_direction():
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	travelled = 0
	return dirs[rand.randi_range(0, 3)]

func take_hit():
	health -= 1
	if health <= 0:
		die()
	
func squish():
	die()
	
func die():
	emit_signal("enemy_killed")
	queue_free()

func _on_Enemy_area_entered(area):
	if area.name == "Farmer":
		area.die()

func _on_AITimer_timeout():
	dir = get_random_direction()
	phased_out = false
	$AITimer.start(THINK_TIME)

func move_toward_target(target):
	dir = (target - self.global_position).normalized()
	$AITimer.start(PERSUE_TIME)

func go_to_target(target):
	var goto = (target - self.global_position).normalized()
	if abs(goto.x) > abs(goto.y):
		if goto.x <= 0:
			dir = Vector2.LEFT
		elif goto.x > 0:
			dir = Vector2.RIGHT
	else:
		if goto.y <= 0:
			dir = Vector2.UP
		elif goto.y > 0:
			dir = Vector2.DOWN
	travelled = 0
	$AITimer.stop()
	$AITimer.start(THINK_TIME)
	
func _on_PhaseOut_area_entered(area):
	if	area.name == "Farmer" or area.name == "Potato":
		phased_out = true
		$AITimer.stop()
		move_toward_target(area.global_position)
		
func _on_PhaseIn_area_entered(area):
	if  area.name == "Farmer" or area.name == "Potato":
		phased_out = false
		go_to_target(area.global_position)
		$AITimer.start(THINK_TIME)


func _on_Enemy_area_exited(area):
	pass # Replace with function body.
