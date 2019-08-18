
###############################################################################
"""
<> PlayerMove03.gd <> by David Lang <>

Simulate hover-craft style vehicle controls.  Need to use 'RigidBody' node as
base node of vehicle for its capabilities of rotational physics upon collision.

TO-DOS:

issue ... 'feel' of controls ...
Controls almost feel too real.  Due to the 100% physics application of the
'RigidBody' node, the controls are almost too realistic.  Two examples that are
most relevant are:  Mouse left/right rotation floats to a stop, and WASD drift
controls take too long to redirect.

UPDATES:

2019-08-17 ... get working 'RigidBody' controls ...
Base stable script.  Keyboard controls (WASD or directional pad) move vehicle
forward/backward and strafe left/right.  Mouse controls rotate vehicle
left/right and rotate camera up/down.
"""
###############################################################################

extends RigidBody

onready var pivot = $Pivot

const FRICTION = 0.0
const THRUST_DAMP = 0.05
const SPIN_DAMP = 0.99

const THRUST = 0.2
const SPIN = 3.0

const MOUSE_SENSITIVITY = 0.0015

var vel = Vector3()
var rot = Vector3()

###############################################################################

func _ready():
	# Initiate mouse capture.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Initiate physics settings.
	physics_material_override.set_friction(FRICTION)
	set_linear_damp(THRUST_DAMP)
	set_angular_damp(SPIN_DAMP)

func _input(event):
	""" Mouse uncapture/capture controls. """
	# Uncapture mouse when 'esc' is pressed.
	if event.is_action_pressed('ui_cancel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Recapture mouse if 'left-mouse-button' is pressed while the mouse cursor
	# is in the screen window.
	if event.is_action_pressed('click_left'):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().set_input_as_handled()

func _unhandled_input(event):
	""" Mouse controls (while captured). """
	# Only apply mouse motion event if mouse is captured.
	var mouse_capture = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and mouse_capture:
		# Mouse motion on the x-axis translates to 'Player' motion on
		# the y-axis.
		rot = Vector3(0, -event.relative.x * MOUSE_SENSITIVITY * SPIN, 0)
		# Mouse motion on the y-axis translates to 'pivot' motion on the z-axis
		# and apply clamp.
		pivot.rotate_z(-event.relative.y * MOUSE_SENSITIVITY)
		pivot.rotation.z = clamp(pivot.rotation.z, -1.2, 0.6)

func getInput():
	""" WASD controls. """
	vel = Vector3()
	# Get WASD up/down input and apply to 'vel' x-axis (forward/backward).	
	if Input.is_action_pressed('ui_up'):
		vel += Vector3(THRUST, 0, 0)
	if Input.is_action_pressed('ui_down'):
		vel += Vector3(-THRUST, 0, 0)
	# Get WASD left/right input and apply to 'vel' z-axis (strafe left/right).
	if Input.is_action_pressed('ui_left'):
		vel += Vector3(0, 0, -THRUST)
	if Input.is_action_pressed('ui_right'):
		vel += Vector3(0, 0, THRUST)
	return vel

func _process(delta):
	vel = getInput()
	# Rotate 'vel' based on rotation of 'Player'.
	vel = vel.rotated(Vector3.UP, rotation.y)

func _physics_process(delta):
	apply_torque_impulse(rot)
	apply_central_impulse(vel)














