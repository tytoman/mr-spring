class_name MrSpring extends CharacterBody2D

## An interface for the player to communicate with the outside.

signal request_kill()
signal dead()

@onready var _dead_state: Dead = $StateMachine/Dead


func _ready() -> void:
	_dead_state.dead.connect(func() -> void: dead.emit())


func kill() -> void:
	# If transit directly to the dead state from here like:
	# state_machine.transit_state(dead_state),
	# if can transit from the dead state to the dead state.
	# Therefore, notify as a signal to the child nodes.
	request_kill.emit()
