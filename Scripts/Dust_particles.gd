extends CPUParticles2D

func _ready():
	emitting = true
	$Timer.start()
	yield($Timer, "timeout")
	queue_free()
