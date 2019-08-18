
##########################################################################
"""
'PlayerMove02.gd'
Player controls for a 'KinematicBody' Player.  Has all desired physics and
controls except the Player's rotation is not effected by its environment.
The Player's body needs to rotate in line with a slope as it moves up a
slope; like a car driving up a hill.
"""
##########################################################################



extends KinematicBody

onready var pivot = $Pivot
onready var camera = $Pivot/Camera

const GRAVITY = 1000
const THRUST = 1500
const MAX_SPEED = 12
const MOUSE_SENS = 0.0015

var acc = Vector3()
var vel = Vector3()
var pos = Vector3()

var spd = Vector2()



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	""" General controls. """
	# Uncapture mouse when 'esc' is pressed.
	if event.is_action_pressed('ui_cancel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Recapture mouse if 'left-mouse-button' is pressed while the mouse
	# cursor is in the screen window.
	if event.is_action_pressed('click_left'):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().set_input_as_handled()

func _unhandled_input(event):
	""" Mouse controls. """
	# Only apply mouse motion event if mouse is also captured.
	var mouse_capture = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and mouse_capture:
		
		# Mouse motion on the x-axis translates to 'Thing' motion on
		# the y-axis.
		rotate_y(-event.relative.x * MOUSE_SENS)
		# Mouse motion on the y-axis translates to 'pivot' motion on the
		# z-axis and apply clamp.
		pivot.rotate_z(-event.relative.y * MOUSE_SENS)
		pivot.rotation.z = clamp(pivot.rotation.z, -1.2, 0.6)

func getInputDirection():
	""" Directional controls. """
	var dir = Vector3()
	
	if Input.is_action_pressed('ui_up'):
		dir += -camera.global_transform.basis.z
	if Input.is_action_pressed('ui_down'):
		dir += camera.global_transform.basis.z
	if Input.is_action_pressed('ui_left'):
		dir += -camera.global_transform.basis.x
	if Input.is_action_pressed('ui_right'):
		dir += camera.global_transform.basis.x
	
	dir = dir.normalized()
	
	return dir

func _physics_process(delta):
	vel = Vector3()
	acc = getInputDirection() * THRUST
	vel.y -= GRAVITY * delta
	vel += acc * delta
	pos += vel * delta
	
	# 'spd' used to clamp horizontal velocity with 'MAX_SPEED'.
	spd = Vector2(pos.x, pos.z)
	spd = spd.clamped(MAX_SPEED)
	pos.x = spd.x
	pos.z = spd.y
	
	pos = move_and_slide(pos, Vector3.UP)


