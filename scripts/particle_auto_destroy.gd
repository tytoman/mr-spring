class_name ParticleAutoDestroy extends GPUParticles2D


func _ready() -> void:
	emitting = true
	one_shot = true
	finished.connect(queue_free)
