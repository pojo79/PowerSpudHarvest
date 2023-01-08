extends Area2D


export var MOVE_SPEED = 30
export var SHOOT_PAUSE_TIME = .35

var facing_vector = Vector2.RIGHT
var spray_shot = preload("res://SprayShot.tscn")
var playback_pos = 0
var shooting = false
var dying = false
onready var window_size = get_viewport_rect().size

signal farmer_die

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset(pos):
	self.position = pos
	dying = false
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not shooting and not dying:
		var move_dir = get_move_dir()
		var new_pos = self.position + ((move_dir * MOVE_SPEED) * delta)
		#if (not (new_pos.x < 0 or new_pos.x > window_size.x) or (new_pos.y < 32 or new_pos.y > window_size.y)):
		self.position.x = clamp(new_pos.x, 8, window_size.x -8)
		self.position.y = clamp(new_pos.y, 40, window_size.y -8)
	
	if not shooting and Input.is_action_just_pressed("action1"):
		shoot()
		
func shoot():
	$StationaryTimer.start(SHOOT_PAUSE_TIME)
	$ShootSound.play()
	var spray = spray_shot.instance()
	spray.set_vel_and_pos($Center.global_position, facing_vector)
	get_parent().add_child(spray)
	shooting = true
	

func get_move_dir():
	var move_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		$Farmer.flip_h = true
		facing_vector = Vector2.LEFT
		move_dir = Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		facing_vector = Vector2.RIGHT
		$Farmer.flip_h = false
		move_dir = Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		facing_vector = Vector2.UP
		$Farmer.flip_h = true
		move_dir = Vector2.UP
	if Input.is_action_pressed("ui_down"):
		facing_vector = Vector2.DOWN
		$Farmer.flip_h = false
		move_dir = Vector2.DOWN
		
	if move_dir != Vector2.ZERO:
		if not $BackgroundMusic.playing:
			$BackgroundMusic.play(playback_pos)
		facing_vector = move_dir
		$Farmer.play()
	else:
		playback_pos = $BackgroundMusic.get_playback_position()
		$BackgroundMusic.stop()
		$Farmer.stop()
		$Farmer.frame = 0

	return move_dir

func die():
	if not dying:
		dying = true
		playback_pos = $BackgroundMusic.get_playback_position()
		$BackgroundMusic.stop()
		$DeathAudio.play(0)
		$AnimationPlayer.play("die")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("farmer_die")

func _on_StationaryTimer_timeout():
	shooting = false
