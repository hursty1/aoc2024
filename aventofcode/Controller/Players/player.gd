extends CharacterBody3D
class_name Player

## How fast the player can move m/s
@export var base_speed := 40.0
## How High the player can jump in meters
@export var jump_height := 1.2
## How fast the player will fall after reaching jump height
@export var fall_adjust_multiplier := 1.5

@export_category("Camera")
## Mouse Sensitivity (Default)
@export var mouse_sensitivity: float = 0.0075
## Limits how low a player can look down
@export var bottom_clamp: float = -90.0
## Limits how high a player can look
@export var top_clamp:float = 90.0
## Weapon aiming multiplier
@export var aim_speed_multiplier := 0.7



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
# Stores the direction the player is trying to look this frame.
var mouseMotion := Vector2.ZERO


## References
@onready var camera = $CameraTarget/Camera
@onready var camera_default_fov = camera.fov
@onready var camera_target = $CameraTarget

@onready var weapon_camera = $SubViewportContainer/SubViewport/WeaponCamera
@onready var weapon_camera_default_fov = weapon_camera.fov

@onready var third_person_camera = $CameraTarget/Camera/SpringArm3D/ThirdPerson
@onready var spring_arm_3d = $CameraTarget/Camera/SpringArm3D

@onready var weapon_container = %WeaponContainer

## Camera Sway
var cam_rotation_amount:float = 0.05
var mouse_input:Vector2
var weapon_rotation_amount:float = 1

enum VIEW {
	FIRST_PERSON,
	THIRD_PERSON_BACK
}

# Updates the cameras to swap between first and third person.
var view := VIEW.FIRST_PERSON:
	set(value):
		view = value
		match view:
			VIEW.FIRST_PERSON:
				# Get the fov of the current camera and apply it to the target.
				camera.fov = get_viewport().get_camera_3d().fov
				camera.current = true
				weapon_camera.current = true
				#UserInterface.hide_reticle(false)
			VIEW.THIRD_PERSON_BACK:
				# Get the fov of the current camera and apply it to the target.
				third_person_camera.fov = get_viewport().get_camera_3d().fov
				third_person_camera.current = true
				weapon_camera.current = false
				#UserInterface.hide_reticle(true)



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	## User Interface load

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_input = event.relative * mouse_sensitivity
		mouseMotion = -event.relative * mouse_sensitivity
		if Input.is_action_pressed(GameSettings.FIRE):
			mouseMotion *= aim_speed_multiplier
	
	if event.is_action_pressed('ui_cancel'): #debug 
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		UserInterface.paused = !UserInterface.paused
	
func _physics_process(delta):
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_adjust_multiplier
	
	#if Input.is_action_just_pressed(GameSettings.JUMP) and is_on_floor():
		#velocity.y = get_jump_velocity()
			
	##flying
	if Input.is_action_pressed("jump"):
		velocity.y = 12
	else:
		velocity.y = 0
	## Direction
	var input_dir = Input.get_vector(GameSettings.MOVE_LEFT, GameSettings.MOVE_RIGHT, GameSettings.MOVE_FORWARD, GameSettings.MOVE_BACK)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	## Movement / aiming
	if direction:
		velocity.x = lerp(velocity.x, direction.x * base_speed, base_speed * delta)
		velocity.z = lerp(velocity.z, direction.z * base_speed, base_speed * delta)
		if Input.is_action_pressed(GameSettings.WEAPON_AIM):
			pass
			#should add aim speed reduction
			#velocity.x *= aim_speed_multiplier #??
			#velocity.z *= aim_speed_multiplier #??
	else:
		velocity.x = move_toward(velocity.x, 0, base_speed)
		velocity.z = move_toward(velocity.z, 0, base_speed)
	handle_camera_rotation()
	smooth_camera_zoom(delta)
	move_and_slide()
	cam_tilt(input_dir.x, delta)
	weapon_tilt(input_dir.x, delta)
	weapon_sway(delta)

func _unhandled_input(event):
	if event.is_action_pressed("toggle_view"):
		cycle_view()

func cycle_view() -> void:
	# Swap from third to first person and vice versa.
	match view:
		VIEW.FIRST_PERSON:
			view = VIEW.THIRD_PERSON_BACK
			# Set the default third person zoom to halfway between min and max.
			#zoom = lerp(min_zoom, max_zoom, 0.5)
		VIEW.THIRD_PERSON_BACK:
			view = VIEW.FIRST_PERSON
		_:
			view = VIEW.FIRST_PERSON


func _process(delta):
	aim(delta)
	
func aim(delta) -> void:
	if Input.is_action_pressed(GameSettings.WEAPON_AIM):
		camera.fov = lerp(camera.fov, camera_default_fov * aim_speed_multiplier, delta * 20)
		weapon_camera.fov = lerp(weapon_camera.fov, weapon_camera_default_fov * aim_speed_multiplier, delta * 20)
	else:
		camera.fov = lerp(camera.fov, camera_default_fov, delta * 30)
		weapon_camera.fov = lerp(weapon_camera.fov, weapon_camera_default_fov, delta * 30)
	
func get_jump_velocity():
	return sqrt(jump_height * 2 * gravity)

func handle_camera_rotation() -> void:
	rotate_y(mouseMotion.x)
	camera_target.rotate_x(mouseMotion.y)
	camera_target.rotation_degrees.x = clampf(
		camera_target.rotation_degrees.x, -90, 90
		)
	mouseMotion = Vector2.ZERO

func smooth_camera_zoom(delta: float) -> void:
	spring_arm_3d.spring_length = lerp(
		spring_arm_3d.spring_length,
		4.0,
		delta * 10.0
	)

func cam_tilt(input_dir:float, delta:float) -> void:
	if camera:
		camera.rotation.z = lerp(camera.rotation.z, -input_dir * cam_rotation_amount, 10 * delta)
func weapon_tilt(input_dir:float, delta:float) -> void:
	if weapon_container:
		weapon_container.rotation.z = lerp(weapon_camera.rotation.z, -input_dir * weapon_rotation_amount * 0.1, 10 * delta)
func weapon_sway(delta:float):
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10*delta)
	weapon_container.rotation.x = lerp(weapon_container.rotation.x, mouse_input.y * weapon_rotation_amount*0.5, 10 * delta)
	weapon_container.rotation.y = lerp(weapon_container.rotation.y, mouse_input.x * weapon_rotation_amount*0.5, 10 * delta)
