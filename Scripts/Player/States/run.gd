# run_state.gd
extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()
 
func enter() -> void:
	player.animation_player.play("Running")
 
func physics_update(_delta: float) -> void:
	if !player.input_manager.movement_direction == Vector3.ZERO:
		player.visuals.look_at(player.position + player.input_manager.movement_direction * -1)
 
	player.velocity.x = player.input_manager.movement_direction.x * player.RUNNING_SPEED * _delta
	player.velocity.z = player.input_manager.movement_direction.z * player.RUNNING_SPEED * _delta
	
	player.left_ground = player.was_on_floor and !player.is_on_floor()
	
	player.move_and_slide()
	
	if not player.is_on_floor() && player.input_manager.input_dir.y<0 || player.input_manager.jump_pressed and player.is_on_floor():
		state_machine.transition_to("AutoJump")
	elif not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif player.input_manager.movement_direction == Vector3.ZERO:
		state_machine.transition_to("Idle")
	elif player.is_on_floor():
		if player.input_manager.attack_pressed:
			state_machine.transition_to("Attack")	
		elif player.input_manager.sprint_pressed:
			state_machine.transition_to("Run")
		elif !player.input_manager.sprint_pressed:
			state_machine.transition_to("Walking")
