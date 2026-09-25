extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()
#@onready var animation_tree: AnimationTree = $"../../visuals/LokomotionBase/AnimationTree"
#@onready var visuals: Node3D = $"../../visuals"


func enter() -> void:
#	if player.velocity.x > 0:
#		player.animation_player.play("StrafeRightWalk")
#	else:
#		player.animation_player.play("StrafeLeftWalk")

	#print(player.visuals.animation_tree)
	#print(player.visuals.animation_playback)

	player.animation_player.stop()
	player.animation_tree.active = true
	player.visuals.animation_playback.start(&"StrafeWalk")
 
func physics_update(_delta: float) -> void:	
	#if !player.input_manager.movement_direction == Vector3.ZERO:
	#	player.visuals.look_at(player.position + player.input_manager.movement_direction * -1)
 
	player.visuals.rotation.y = player.camera_mount.rotation.y + deg_to_rad(180)
	
	player.velocity.x = player.input_manager.movement_direction.x * player.SPEED * _delta
	player.velocity.z = player.input_manager.movement_direction.z * player.SPEED * _delta
	
	player.move_and_slide()
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	if not player.input_manager.lockOn_pressed:
		state_machine.transition_to("Idle")
	#elif player.input_manager.attack_pressed:
	#	state_machine.transition_to("Attack")	
	elif player.input_manager.movement_direction == Vector3.ZERO:
		state_machine.transition_to("LockOn")
	elif player.input_manager.movement_direction != Vector3.ZERO && player.input_manager.sprint_pressed:
		state_machine.transition_to("StrafeRun")

func exit() -> void:
	if not player.input_manager.lockOn_pressed:
		player.animation_tree.active = false
