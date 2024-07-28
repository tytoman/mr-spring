class_name DeathArea extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_enter)
	monitorable = false


func _on_body_enter(body: Node2D) -> void:
	if body.has_method("kill"):
		body.kill()
