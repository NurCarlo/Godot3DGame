extends State
 
@onready var player: CharacterBody3D = owner
@onready var state_machine: StateMachine = get_parent()
 
var AnimationCanelPercentage = 0.5

func enter() -> void:
	if player.fallTime > 0.5:
		player.animation_player.play("LandingHard")
	else:
		player.animation_player.play("Landing")
	player.animation_player.set_section(0.28,1.1)

func physics_update(_delta: float) -> void:	
	if player.fallTime > 0.1:
		player.velocity.x = 0.0
		player.velocity.z = 0.0
		print("länger als 0,1s gefallen")
	else:
		# 55 soll den "rutschfaktor" darstellen 
		# muss sowiso mal schauen wie das mit dem, rutschen istda kann ich das vilt in eine variable auslagern
		player.velocity.x *= 55 * _delta
		player.velocity.z *= 55 * _delta
		AnimationCanelPercentage = 0.3
		print("nicht lange gefallen")
	
	player.move_and_slide()
	
	if player.animation_player.current_animation_position / player.animation_player.current_animation_length > 0.5:
		if player.input_manager.movement_direction != Vector3.ZERO:
			state_machine.transition_to("Walking")
		elif player.input_manager.movement_direction != Vector3.ZERO && player.input_manager.sprint_pressed:
			state_machine.transition_to("Run")
	player.animation_player.reset_section()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	state_machine.transition_to("Idle")

func exit() -> void:
	player.fallTime=0.0
