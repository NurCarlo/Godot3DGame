# jump_state.gd
extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()

func enter() -> void:
	player.velocity.y = player.JUMP_VELOCITY
	player.animation_player.play("Jump")	
	player.is_jumping = true
 
func physics_update(_delta: float) -> void:	
	player.move_and_slide()
 
	if player.velocity.y <= -6.1:
		state_machine.transition_to("Fall")
	elif player.is_on_floor():
		state_machine.transition_to("Land")
		
func exit() -> void:
	player.is_jumping = false
