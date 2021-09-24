extends Node2D

var score = 0
var combo = 0

var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0

var bpm = 96

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

var lane = 0
var rand = 0
var projectile = load("res://scenes/Projectile.tscn")

var instance
var pos

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioPlayer.play()
	print("game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AudioPlayer_beat(position):
	song_position_in_beats = position
	if song_position_in_beats > 36:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 98:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 104:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 115:
		if get_tree().change_scene("res://scenes/GameOver.tscn") != OK:
			print ("Error changing scene to End")

func _on_AudioPlayer_measure(position):
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)
	
func _spawn_notes(to_spawn):
	if to_spawn > 0:
		lane = randi() % 4
		instance = projectile.instance()
		if lane == 0:
			pos = $PositionTL.position
		elif lane == 1:
			pos = $PositionTR.position
		elif lane == 2:
			pos = $PositionBL.position
		elif lane == 3:
			pos = $PositionBR.position
		instance.initialize(pos)
		add_child(instance)
	if to_spawn > 1:
		while rand == lane:
			rand = randi() % 4
		lane = rand
		instance = projectile.instance()
		if lane == 0:
			pos = $PositionTL.position
		elif lane == 1:
			pos = $PositionTR.position
		elif lane == 2:
			pos = $PositionBL.position
		elif lane == 3:
			pos = $PositionBR.position
		instance.initialize(pos)
		add_child(instance)
		
func increment_score(number):
	if number == 0:
		$HUD/Quality.text = ""
	elif number == 1:
		$HUD/Quality.text = "Okay"
	elif number == 2:
		$HUD/Quality.text = "Good !"
	elif number == 3:
		$HUD/Quality.text = "PERFECT!!"
	GlobalScope.score += number
	$HUD/Score.text = str(int($HUD/Score.text) + number)
	
func shake():
	$Camera2D.shake(0.05, 80, 10)
