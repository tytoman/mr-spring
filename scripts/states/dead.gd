class_name Dead extends StateBase


signal dead()

@onready var _mr_spring: MrSpring = $"../.."
@onready var _sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"


func _on_state_enter() -> void:
	_sprite.play("dead")
	
	await get_tree().create_timer(0.3).timeout
	
	dead.emit()
	_mr_spring.queue_free()
