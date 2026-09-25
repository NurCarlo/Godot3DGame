# attack_state.gd
extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()
 
func enter() -> void:
	player.animation_player.play("kick") 


func physics_update(_delta: float) -> void:
	player.velocity.x *= 0.9 * _delta
	player.velocity.z *= 0.9 * _delta
	
	player.move_and_slide()
		
	if player.animation_player.current_animation_position / player.animation_player.current_animation_length > 0.7:
		if player.input_manager.movement_direction != Vector3.ZERO:
			state_machine.transition_to("Walking")
		elif player.input_manager.movement_direction != Vector3.ZERO && player.input_manager.sprint_pressed:
			state_machine.transition_to("Run")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	state_machine.transition_to("Idle")
