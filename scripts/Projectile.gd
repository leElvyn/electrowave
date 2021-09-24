extends Area2D

const TARGET_Y = 300
const TARGET_X = 512

var target = Vector2(TARGET_X, TARGET_Y)

const DIST_TO_TARGET = floor(sqrt((300^2) + (512^2)))


const TL_LANE_SPAWN = Vector2(0, 0)
const TR_LANE_SPAWN = Vector2(0, 1024)
const BL_LANE_SPAWN = Vector2(600, 0)
const BR_LANE_SPAWN = Vector2(600, 1024)

var space_state 
var result

var frame

var speed = 0
var hit = false

var dead = false
var fade_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	if dead:
		modulate.a -= 0.0328
		fade_count += 1
	if fade_count > 30:
		get_parent().increment_score(0)
		queue_free()

func touched(ok, good, perfect):
	if dead:
		return
	if $AnimatedSprite.frame == 1:
		if perfect:
			get_parent().increment_score(3)
		elif good:
			get_parent().increment_score(2)
		elif ok:
			get_parent().increment_score(1)
		get_parent().shake()
		queue_free()
	
func initialize(pos):
	position = pos
	var direction = (pos - target).normalized()
	
	speed = 150
	$AnimatedSprite.frame = 0 if randf() > 0.25 else 1
	

func _physics_process(delta):
	if !hit:
		if position == target:
			dead = true
		position = position.move_toward(target, delta * speed)

	else:
		$Node2D.position.y -= speed * delta

func _input(event):
	if event is InputEventMouseButton:
		space_state = get_world_2d().direct_space_state
		result = space_state.intersect_point(event.position, 1, [], 2147483647, true, true)
		if result:
			if result[0]["collider_id"] == get_instance_id():
				if $AnimatedSprite.frame == 0:
					$AnimatedSprite.frame = 1
