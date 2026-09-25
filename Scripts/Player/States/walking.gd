# walking_state.gd
extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()
 
func enter() -> void:
	player.animation_player.play("Walk")
 
func physics_update(_delta: float) -> void:
	#player.velocity += player.get_gravity() * delta * 2
	
	if !player.input_manager.movement_direction == Vector3.ZERO:
		player.visuals.look_at(player.position + player.input_manager.movement_direction * -1)
 
	player.velocity.x = player.input_manager.movement_direction.x * player.SPEED * _delta
	player.velocity.z = player.input_manager.movement_direction.z * player.SPEED * _delta
	
	player.move_and_slide()
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif player.input_manager.jump_pressed:
		state_machine.transition_to("AutoJump")
	elif player.input_manager.movement_direction == Vector3.ZERO:
		state_machine.transition_to("Idle")
	elif player.input_manager.attack_pressed:
		state_machine.transition_to("Attack")	
	elif player.input_manager.lockOn_pressed && abs(player.velocity.x) > abs(player.velocity.z):
		state_machine.transition_to("Strafe")
	elif player.input_manager.lockOn_pressed && abs(player.velocity.x) > abs(player.velocity.z) && player.input_manager.sprint_pressed:
		state_machine.transition_to("SrafeRun")
	elif player.input_manager.sprint_pressed:
		state_machine.transition_to("Run")
