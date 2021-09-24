extends Sprite


const input = "spacebar"

var current_notes = []

var ok = false
var good = false
var perfect = false

signal touched

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _unhandled_input(event):
	if event.is_action("space_bar"):
		if event.is_action_pressed("space_bar", false):
			if current_notes:
				current_notes.touched(ok, good, perfect)
				_reset()
			else:
				get_parent().increment_score(0)
			

func _reset():
	current_notes = null
	ok = false
	good = false
	perfect = false


func _on_OkArea_area_entered(area):
	if area.is_in_group("note"):
		print("ok")
		ok = true
		current_notes = area


func _on_GoodArea_area_entered(area):
	if area.is_in_group("note"):
		print("good")
		good = true
		current_notes = area


func _on_PerfectArea_area_entered(area):
	if area.is_in_group("note"):
		print("perfect")
		perfect = true
		current_notes = area
