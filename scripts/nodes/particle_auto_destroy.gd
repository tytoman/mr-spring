class_name ParticleAutoDestroy extends GPUParticles2D

## GPUParticle2D which is automatically discarded at the end of the emission.

func _ready() -> void:
	emitting = true
	one_shot = true
	finished.connect(queue_free)
