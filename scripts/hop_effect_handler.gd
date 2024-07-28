class_name EffectHandler extends Node


@export var _hop_particle: PackedScene
@export var _hop_sound: AudioStream
@export var _dead_sound: AudioStream

@onready var _audio_player: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"
@onready var _move_state: Move = $"../StateMachine/Move"


func _ready() -> void:
	_move_state.hopped.connect(_hop_effect)
	_move_state.damaged.connect(_dead_effect)


func _hop_effect(collision: KinematicCollision2D) -> void:
	_audio_player.stream = _hop_sound
	_audio_player.play()
	
	var fx: Node2D = _hop_particle.instantiate()
	fx.position = collision.get_position()
	fx.look_at(fx.position + collision.get_normal())
	get_tree().current_scene.add_child(fx)


func _dead_effect() -> void:
	_audio_player.stream = _dead_sound
	_audio_player.play()
