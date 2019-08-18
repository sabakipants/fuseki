
extends KinematicBody

var rot = 0          # rotation
var acc = Vector3()  # acceleration
var vel = Vector3()  # velocity
var pos = Vector3()  # position

export var GRAVITY = 100
export var ROT_SPEED = 2.6
export var THRUST = 500

var apply_grav = Vector3.DOWN * GRAVITY



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _physics_process(delta):
	
#	print(rot)
	
#	rot = rotationControls(delta)
	acc = accelerationControls(rot)
	
	vel = Vector3()
	
	vel += acc * delta
	pos += vel * delta
	pos += apply_grav * delta
	
	pos = move_and_slide(pos, Vector3.UP)



func rotationControls(delta):
	"""
	- Need to save 'rot' from previous frame to apply back to 'rot'
	after applying user input.
	- Reset 'rot', apply 'ROT_SPEED' with user input, then apply
	'rot' to Player.
	- Return saved 'rot' value to apply accurate 'rot' to acceleration.
	"""
#	print(rot)
	var save_rot = rot
	rot = 0
#	if Input.is_action_pressed('ui_left'):   rot = ROT_SPEED * delta
#	if Input.is_action_pressed('ui_right'):  rot = -ROT_SPEED * delta
	rotate_y(rot)
	rot += save_rot
	
	return rot



func accelerationControls(rot):
	"""
	- Reset 'acc', apply 'THRUST' with user input.  Take 'rot' to
	apply 'THRUST' in the correct direction.
	"""
	acc = Vector3()	
	if Input.is_action_pressed('ui_up'):
		acc = Vector3(THRUST, 0, 0).rotated(Vector3(0, 1, 0), rot)
	
	return acc



func _input(event):
	if event.is_action_pressed('ui_cancel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed('click_left'):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _unhandled_input(event):
	var mouse_captured = (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion and mouse_captured:
#		rot = -lerp(0, ROT_SPEED, event.relative.x / 10)
		rotate_y(-lerp(0, ROT_SPEED, event.relative.x / 10))













