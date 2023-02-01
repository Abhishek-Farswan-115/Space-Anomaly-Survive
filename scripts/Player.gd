extends CharacterBody3D


const SPEED = 12.0
const JUMP_VELOCITY = 10

var mouse_sensitivity = 0.1
var step = 24
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * 5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("right", "left", "back", "front")
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, step*delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, step*delta)
		if is_on_floor():
			$AnimationTree.set("parameters/Transition/current", 0)
	else:
		velocity.x = move_toward(velocity.x, 0, step*delta)
		velocity.z = move_toward(velocity.z, 0, step*delta)
		if is_on_floor():
			$AnimationTree.set("parameters/Transition/current", 1)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x) * mouse_sensitivity)
		$head.rotate_x(deg_to_rad(event.relative.y) * mouse_sensitivity)
