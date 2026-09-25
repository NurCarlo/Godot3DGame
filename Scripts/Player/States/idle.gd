# idle_state.gd
extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()
 
func enter() -> void:
	player.animation_player.play("Idle") 

func physics_update(_delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	player.move_and_slide()

	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif player.input_manager.jump_pressed:
		state_machine.transition_to("AutoJump")
	elif player.input_manager.attack_pressed:
		state_machine.transition_to("Attack")	
	elif player.input_manager.lockOn_pressed:
		state_machine.transition_to("LockOn")
	elif player.input_manager.movement_direction != Vector3.ZERO:
		state_machine.transition_to("Walking")
	elif player.input_manager.movement_direction != Vector3.ZERO && player.input_manager.sprint_pressed:
		state_machine.transition_to("Run")
