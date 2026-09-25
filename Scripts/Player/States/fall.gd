# fall_state.gd
extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()

func enter() -> void:
	player.animation_player.play("Falling")

func physics_update(_delta: float) -> void:	
	print("falltime:",player.fallTime)
	
	player.fallTime+=1*_delta
	
	player.move_and_slide()
	
	if player.is_on_floor():
			state_machine.transition_to("Land")
		#if player.input_manager.movement_direction != Vector3.ZERO:
		#	state_machine.transition_to("Walking")
		#elif player.input_manager.movement_direction != Vector3.ZERO && player.input_manager.sprint_pressed:
		#	state_machine.transition_to("Run")
		#else:
		#	state_machine.transition_to("Idle")
