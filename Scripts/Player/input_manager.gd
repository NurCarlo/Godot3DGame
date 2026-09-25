class_name PlayerInput
extends Node

@onready var player: CharacterBody3D = owner

var input_dir := Vector2.ZERO
var movement_direction := Vector3.ZERO

var camera_input_dir := Vector2.ZERO
var camera_direction := Vector3.ZERO

var jump_pressed := false
var sprint_pressed := false
var attack_pressed := false
var lockOn_pressed := false

#func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# maus camera controlls
	if event is InputEventMouseMotion:
		owner.rotate_y(deg_to_rad(-event.relative.x * owner.sens_horizontal))
		owner.visuals.rotate_y(deg_to_rad(event.relative.x * owner.sens_horizontal))
		owner.camera_mount.rotate_x(deg_to_rad(-event.relative.y * owner.sens_vertical))
		owner.camera_mount.rotation.x = clamp(owner.camera_mount.rotation.x, deg_to_rad(-90),deg_to_rad(45))

func _physics_process(_delta: float) -> void:
	input_dir = Input.get_vector(
		"moveLeft",
		"moveRight",
		"moveUp",
		"moveDown"
	)
	
	movement_direction = (player.transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	
	camera_input_dir = Input.get_vector(
		"lookLeft", 
		"lookRight", 
		"lookUp", 
		"lookDown"
	)
	
	camera_direction = (Vector3(camera_input_dir.x, camera_input_dir.y,0)).normalized()
	
	if camera_direction:
		player.rotate_y(-camera_direction.x * player.sens_horizontal_controller * _delta)
		player.visuals.rotate_y(camera_direction.x * player.sens_horizontal_controller * _delta)
		player.camera_mount.rotate_x(-camera_direction.y * player.sens_vertical_controller * _delta)
		player.camera_mount.rotation.x = clamp(player.camera_mount.rotation.x, deg_to_rad(-70),deg_to_rad(45))
	
	jump_pressed = Input.is_action_just_pressed("jump")
	sprint_pressed = Input.is_action_pressed("sprint")
	#attack_pressed = Input.is_action_just_pressed("attack")
	lockOn_pressed= Input.is_action_pressed("lockOn")
	
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
