extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()
#@onready var animation_tree: AnimationTree = $"../../visuals/LokomotionBase/AnimationTree"

func enter() -> void:
	#if player.velocity.x > 0:
#		player.animation_player.play("StrafeRightRun")
#	else:
#		player.animation_player.play("StrafeLeftRun")
	player.animation_player.stop()
	player.animation_tree.active = true
	player.visuals.animation_playback.travel(&"StrafeRun")
 
func physics_update(_delta: float) -> void:	
	#if !player.input_manager.movement_direction == Vector3.ZERO:
	#	player.visuals.look_at(player.position + player.input_manager.movement_direction * -1)
 
	player.visuals.rotation.y = player.camera_mount.rotation.y + deg_to_rad(180)
	
	player.velocity.x = player.input_manager.movement_direction.x * (player.RUNNING_SPEED -50) * _delta
	player.velocity.z = player.input_manager.movement_direction.z * (player.RUNNING_SPEED -50)* _delta
	
	player.move_and_slide()
	

	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	if not player.input_manager.lockOn_pressed:
		state_machine.transition_to("Idle")
	#elif player.input_manager.attack_pressed:
	#	state_machine.transition_to("Attack")	
	#if not player.is_on_floor() && player.input_manager.input_dir.y<0 || player.input_manager.jump_pressed and player.is_on_floor():
	#	state_machine.transition_to("AutoJump")
	elif player.input_manager.movement_direction == Vector3.ZERO:
		state_machine.transition_to("LockOn")
	elif player.input_manager.movement_direction != Vector3.ZERO && not player.input_manager.sprint_pressed:
		state_machine.transition_to("Strafe")

func exit() -> void:
	if not player.input_manager.lockOn_pressed:
		player.animation_tree.active = false
