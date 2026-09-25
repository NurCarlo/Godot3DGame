
extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var animation_tree: AnimationTree = $"../../visuals/LokomotionBase/AnimationTree"

func enter() -> void:
	animation_tree.active = false 
	player.animation_player.play("Idle") 
	# hier kampfpose oder so	
	#player.animation_player.stop()

func physics_update(_delta: float) -> void:
	
	player.visuals.rotation.y = player.camera_mount.rotation.y + deg_to_rad(180)
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	player.move_and_slide()

	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	if not player.input_manager.lockOn_pressed:
		state_machine.transition_to("Idle")
	#elif player.input_manager.attack_pressed:
	#	state_machine.transition_to("Attack")	
	elif player.input_manager.movement_direction != Vector3.ZERO && player.input_manager.sprint_pressed:
		state_machine.transition_to("StrafeRun")
	elif player.input_manager.movement_direction != Vector3.ZERO:
		state_machine.transition_to("Strafe")
