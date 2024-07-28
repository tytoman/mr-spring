class_name MrSpring extends CharacterBody2D


signal dead()
signal request_kill()

@onready var _dead_state: Dead = $StateMachine/Dead


func _ready() -> void:
	_dead_state.dead.connect(func() -> void: dead.emit())


func kill() -> void:
	request_kill.emit()
