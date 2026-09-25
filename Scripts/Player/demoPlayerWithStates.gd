# player.gd
extends CharacterBody3D
 
var SPEED = 100.0
var RUNNING_SPEED = 350.0
const JUMP_VELOCITY = 7
const AIR_SPEED = 50.0
const GRAVITY := 2.0
 
var sens_horizontal = 0.5
var sens_vertical = 0.5
var sens_horizontal_controller = 3.5
var sens_vertical_controller = 3.5

#auto jump zeugs
var was_on_floor := true
var is_jumping := false
var left_ground := false
var fallTime := 0.0

@onready var animation_player: AnimationPlayer = $visuals/LokomotionBase/AnimationPlayer
@onready var state_machine: Node = $stateMashine
@onready var visuals: Node3D = $visuals
@onready var camera_mount: Node3D = $cameraMount
@onready var input_manager: Node3D = $InputManager
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var animation_tree: AnimationTree = $visuals/LokomotionBase/AnimationTree
@onready var collision_shape_3d_jump: CollisionShape3D = $CollisionShape3DJump
func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta * GRAVITY
	
	#if is_on_floor():
	#	print("on floor")
	#else:
	#	print("not")
	#print("fallTime:",fallTime)
	print("State: ",state_machine.current_state.name,"	Velocity X: ",velocity.x,"	Velocity Z: ",velocity.z,"	Velocity Y: ",velocity.y,"			fallTime: ",fallTime)
