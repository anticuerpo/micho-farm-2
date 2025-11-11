extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

# Añadir la misma lógica de _ready() que en walk_state
func _ready():
	# Si animated_sprite_2d no está asignado, intentar encontrarlo automáticamente
	if not animated_sprite_2d:
		# Buscar en el padre (Player) si existe un AnimatedSprite2D
		if player and player.has_node("AnimatedSprite2D"):
			animated_sprite_2d = player.get_node("AnimatedSprite2D")
		# O buscar en la escena actual
		elif has_node("AnimatedSprite2D"):
			animated_sprite_2d = get_node("AnimatedSprite2D")
		
		# Si aún no se encuentra, mostrar advertencia
		if not animated_sprite_2d:
			push_warning("AnimatedSprite2D no encontrado en tilling_state.gd")

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	# Corregir el nombre del estado (debe ser "idle" no "Idle")
	if animated_sprite_2d and !animated_sprite_2d.is_playing():
		transition.emit("idle")

func _on_enter() -> void:
	# Verificar que animated_sprite_2d no sea null
	if animated_sprite_2d:
		if player.player_direction == Vector2.UP:
			animated_sprite_2d.play("tilling_back")
		elif player.player_direction == Vector2.RIGHT:
			animated_sprite_2d.play("tilling_right")
		elif player.player_direction == Vector2.DOWN:
			animated_sprite_2d.play("tilling_front")
		elif player.player_direction == Vector2.LEFT:
			animated_sprite_2d.play("tilling_left")
		else: 
			animated_sprite_2d.play("tilling_front")
	else:
		print("Error: animated_sprite_2d es null en tilling_state")

func _on_exit() -> void:
	# Verificar que no sea null antes de llamar stop()
	if animated_sprite_2d:
		animated_sprite_2d.stop()
