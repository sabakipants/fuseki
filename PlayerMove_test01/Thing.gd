
extends RigidBody

onready var pivot = $Pivot
onready var camera = $Pivot/Camera

const THRUST = 0.1
const SPIN = 100
const MOUSE_SENS = 0.0015

var vel = Vector3()
var rot = Vector3()



func _ready():

	set_friction(0.1)
	set_angular_damp(1.0)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _input(event):
	if event.is_action_pressed('ui_cancel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed('click_left'):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().set_input_as_handled()



func _unhandled_input(event):
	var mouse_capture = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and mouse_capture:
		rotate_y(-event.relative.x * MOUSE_SENS)
		pivot.rotate_z(-event.relative.y * MOUSE_SENS)
		pivot.rotation.z = clamp(pivot.rotation.z, -1.2, 0.6)



func getInput():

	""" Directional controls. """
	var vel = Vector3()
	
	if Input.is_action_pressed('ui_up'):
		vel += global_transform.basis.x * THRUST
	if Input.is_action_pressed('ui_down'):
		vel += -global_transform.basis.x * THRUST
	if Input.is_action_pressed('ui_left'):
		vel += -global_transform.basis.z * THRUST
	if Input.is_action_pressed('ui_right'):
		vel += global_transform.basis.z * THRUST
	
	vel = vel.normalized()
	
	return vel
	

func _process(delta):
	vel = getInput()
	
	print(vel)
	


func _integrate_forces(state):
	
#	vel = getInput()
	
	apply_central_impulse(vel * state)
	
#	apply_impulse(vel)
	
	apply_torque_impulse(rot * state)






