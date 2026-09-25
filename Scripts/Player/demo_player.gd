extends CharacterBody3D

@onready var camera_mount: Node3D = $cameraMount
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var visuals: Node3D = $visuals

var SPEED = 3.0
const JUMP_VELOCITY = 6

var walking_speed = 3.0
var running_speed = 5.0

var running = false
var was_on_floor := true
var is_jumping := false
#var left_groung = is_on_floor()

var is_locked = false

var sens_horizontal = 0.5
var sens_vertical = 0.5
var sens_horizontal_controller = 3.5
var sens_vertical_controller = 3.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# maus camera controlls
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90),deg_to_rad(45))

func _physics_process(delta: float) -> void:
	if !animation_player.is_playing():
		is_locked = false

	handle_camera_controller(delta)
	handle_quit()
	handle_attac()
	
	# rennen
	if Input.is_action_pressed("sprint"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed
		running = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown") #y- == vorn
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		if !is_locked:
			if running:	
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
					
			visuals.look_at(position + direction)
			
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !is_locked:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
				
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if !is_locked:
		handle_auto_jump(input_dir)
		move_and_slide()
		

func handle_camera_controller(delta):
	var camera_input_dir := Input.get_vector("lookLeft", "lookRight", "lookUp", "lookDown")
	var camera_direction := (Vector3(camera_input_dir.x, camera_input_dir.y,0)).normalized()
	if camera_direction:
		rotate_y(-camera_direction.x * sens_horizontal_controller * delta)
		visuals.rotate_y(camera_direction.x * sens_horizontal_controller * delta)
		camera_mount.rotate_x(-camera_direction.y * sens_vertical_controller * delta)
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-70),deg_to_rad(45))
func handle_quit():
		if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
func handle_attac():
		if Input.is_action_just_pressed("attack") && was_on_floor:
			if animation_player.current_animation != "kick":
				animation_player.play("kick")
				is_locked = true
func handle_auto_jump(input_dir):
	var left_ground = was_on_floor and !is_on_floor()
	if left_ground && SPEED > walking_speed && input_dir.y<0 || Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		velocity.y = JUMP_VELOCITY
		if animation_player.current_animation != "jump2/Jump_002":
			animation_player.play("jump2/Jump_002")
			
	if is_jumping and is_on_floor() and velocity.y <=0.0:
		is_jumping = false
	was_on_floor=is_on_floor()
