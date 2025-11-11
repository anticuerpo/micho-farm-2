# scare_particles.gd
extends GPUParticles2D

func _ready():
	# Configurar propiedades básicas
	emitting = true
	one_shot = true
	lifetime = 0.5
	
	
	amount = 30  # Número de partículas
	explosiveness = 1.0  # Todas las partículas aparecen al mismo tiempo
	
	# Esperar a que termine y autodestruirse
	await get_tree().create_timer(lifetime + 0.1).timeout
	queue_free()
