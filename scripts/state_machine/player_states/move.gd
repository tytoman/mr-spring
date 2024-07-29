class_name Move extends StateBase

## Player's state. Handling inputs, movement and animations.

signal hopped(collision: KinematicCollision2D)
signal damaged()

@export var _jump_speed: float = 140.0
@export var _max_rotation_deg: float = 420.0
@export var _rotation_acceleration: float = 15.0
@export var _gravity: float = 220.0

var _current_rotation_deg: float

@onready var _mr_spring: MrSpring = $"../.."
@onready var _sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var _foot: Marker2D = $"../../Foot"
@onready var _dead_state: Dead = $"../Dead"


func _physics_process(delta: float) -> void:
	# Handle inputs.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Rotation.
	var tgt_rot := _max_rotation_deg * direction
	var diff_rot := tgt_rot - _current_rotation_deg
	_current_rotation_deg += diff_rot * clampf(delta * _rotation_acceleration, 0.0, 1.0)	
	_mr_spring.rotation_degrees += _current_rotation_deg * delta
	
	# Hopping.
	if _mr_spring.is_on_wall():
		var n := _mr_spring.get_wall_normal()
		var up := -_mr_spring.transform.y
		var collision := _mr_spring.get_last_slide_collision()
		var diff := collision.get_position() - _foot.global_position
		if n.dot(up) > 0.17 and diff.length_squared() < 16.0:
			_mr_spring.velocity = _jump_speed * up
			_sprite.play("squat")
			hopped.emit(collision)
		else:
			_kill()
	else:
		_mr_spring.velocity.y += _gravity * delta
		_sprite.play("idle")
	
	_mr_spring.move_and_slide()
	
	# Flip sprite.
	if _mr_spring.get_real_velocity().x < 0.0:
		_sprite.flip_h = true
	elif _mr_spring.get_real_velocity().x > 0.0:
		_sprite.flip_h = false


func _on_state_enter() -> void:
	_mr_spring.request_kill.connect(_kill)


func _on_state_exit() -> void:
	_mr_spring.request_kill.disconnect(_kill)


func _kill() -> void:
	damaged.emit()
	transit_state(_dead_state)
