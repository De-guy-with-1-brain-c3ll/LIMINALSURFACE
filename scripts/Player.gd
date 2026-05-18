extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):

	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.003)
		neck.rotate_x(-event.relative.y * 0.003)
		neck.rotation.x = clamp(neck.rotation.x, -1.2, 1.2)

	if event is InputEventKey and event.keycode == KEY_SPACE and event.pressed:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			

func _physics_process(delta):

	velocity.y -= gravity * delta
	
	var direction = Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		direction -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		direction += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		direction -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		direction += transform.basis.x
	
	direction = direction.normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	move_and_slide()
