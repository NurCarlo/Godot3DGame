extends Node

@onready var demo_player: CharacterBody3D = $".."
@onready var animation_tree: AnimationTree = $LokomotionBase/AnimationTree
@onready var player: CharacterBody3D = owner
@onready var animation_playback: AnimationNodeStateMachinePlayback = \
	animation_tree.get("parameters/playback")

var current_speed = Vector2.ZERO
var strave_acceleration = 4
var target_speed

func _ready() -> void:
	animation_tree.active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if demo_player == null:
		return
		
	if player.state_machine.current_state.name == "StrafeRun":#player.input_manager.lockOn_pressed && player.input_manager.sprint_pressed:
		target_speed =Vector2(player.input_manager.input_dir.x,player.input_manager.input_dir.y).normalized()
		animation_tree.set("parameters/StrafeRun/BlendSpace2D/blend_position", target_speed)
	elif player.state_machine.current_state.name == "Strafe":#player.input_manager.lockOn_pressed:
		target_speed =Vector2(player.input_manager.input_dir.x,player.input_manager.input_dir.y).normalized()
		animation_tree.set("parameters/StrafeWalk/BlendSpace2D/blend_position", target_speed)
	pass
