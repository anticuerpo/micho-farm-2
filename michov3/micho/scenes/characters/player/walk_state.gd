extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50

# Añadir esta función para asegurar que tenemos referencia al AnimatedSprite2D
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
			push_warning("AnimatedSprite2D no encontrado en walk_state.gd")

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	# Verificar que animated_sprite_2d no sea null antes de usarlo
	if animated_sprite_2d:
		if direction == Vector2.UP:
			animated_sprite_2d.play("walk_back")
		elif direction == Vector2.RIGHT:
			animated_sprite_2d.play("walk_right")
		elif direction == Vector2.DOWN:
			animated_sprite_2d.play("walk_front")
		elif direction == Vector2.LEFT:
			animated_sprite_2d.play("walk_left")
	else:
		print("Error: animated_sprite_2d es null")
	
	if direction != Vector2.ZERO:
		player.player_direction = direction 
	
	player.velocity = direction * speed 
	player.move_and_slide()

func _on_next_transitions() -> void:
	if !GameInputEvents.movement_input():
		transition.emit("idle")
	
	if Input.is_action_just_pressed("ui_accept"):
		transition.emit("defending")

func _on_enter() -> void:
	pass

func _on_exit() -> void:
	# Verificar que no sea null antes de llamar stop()
	if animated_sprite_2d:
		animated_sprite_2d.stop()
