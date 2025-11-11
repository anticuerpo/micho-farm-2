extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

# Añadir la misma lógica de _ready() que en otros estados
func _ready():
	# Buscar el Player si no está asignado
	if not player:
		# Buscar en el padre (StateMachine) o abuelo (Player)
		var parent = get_parent()
		if parent and parent.get_parent() is Player:
			player = parent.get_parent() as Player
		else:
			# Buscar en la escena
			var players = get_tree().get_nodes_in_group("player")
			if players.size() > 0:
				player = players[0]
		
		if not player:
			push_warning("Player no encontrado en defending_state.gd")
	
	# Buscar AnimatedSprite2D si no está asignado
	if not animated_sprite_2d:
		if player and player.has_node("AnimatedSprite2D"):
			animated_sprite_2d = player.get_node("AnimatedSprite2D")
		elif has_node("AnimatedSprite2D"):
			animated_sprite_2d = get_node("AnimatedSprite2D")
		
		if not animated_sprite_2d:
			push_warning("AnimatedSprite2D no encontrado en defending_state.gd")

var attack_finished = false

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	# Verificar que player no sea null antes de asignar velocity
	if player:
		# Detener el movimiento durante el ataque
		player.velocity = Vector2.ZERO
		player.move_and_slide()
	else:
		print("Error: player es null en defending_state")

func _on_next_transitions() -> void:
	# Volver a idle cuando termine el ataque
	if attack_finished:
		transition.emit("idle")

func _on_enter() -> void:
	attack_finished = false
	
	# Verificar que ambos no sean null
	if player and animated_sprite_2d:
		# Reproducir animación de defensa según la dirección
		var direction_name = player.get_facing_direction_name()
		var anim_name = "chopping_" + direction_name  # Reutilizamos animación de chopping
		
		animated_sprite_2d.play(anim_name)
		
		# Conectar la señal para detectar cuando termine la animación
		if animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
			animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)
		animated_sprite_2d.animation_finished.connect(_on_animation_finished)
		
		# Realizar el ataque
		perform_defense_attack()
	else:
		print("Error: player o animated_sprite_2d es null en defending_state")
		attack_finished = true  # Forzar transición si no hay referencias

func _on_exit() -> void:
	# Limpiar la conexión de la señal
	if animated_sprite_2d and animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)
	
	attack_finished = false

func _on_animation_finished():
	# Esta función se llama cuando termina la animación
	attack_finished = true
	
	# Desconectar la señal
	if animated_sprite_2d and animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)

func perform_defense_attack():
	# Verificar que player existe
	if not player:
		print("Error: player es null en perform_defense_attack")
		return
	
	# Crear área de ataque temporal
	var attack_area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 80  # Radio de alcance
	
	collision.shape = shape
	attack_area.add_child(collision)
	attack_area.global_position = player.global_position
	
	# Configurar las capas de colisión adecuadas
	attack_area.collision_mask = 2  # Ajusta según tu configuración de capas para enemigos
	
	player.get_parent().add_child(attack_area)  # Agregar al nivel, no al jugador
	
	# Usar un timer para detectar enemigos después de un frame
	await get_tree().process_frame
	
	# Detectar gatos enemigos cercanos
	var enemies = attack_area.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.is_in_group("enemies") and enemy.has_method("get_scared"):
			enemy.get_scared()
			print("¡Gato asustado!")
	
	# Esperar un poco antes de eliminar el área
	await get_tree().create_timer(0.2).timeout
	attack_area.queue_free()
