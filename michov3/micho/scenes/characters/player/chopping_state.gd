extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

func _ready() -> void: 
	# Añadir la búsqueda automática del AnimatedSprite2D
	if not animated_sprite_2d:
		if player and player.has_node("AnimatedSprite2D"):
			animated_sprite_2d = player.get_node("AnimatedSprite2D")
		elif has_node("AnimatedSprite2D"):
			animated_sprite_2d = get_node("AnimatedSprite2D")
		
		if not animated_sprite_2d:
			push_warning("AnimatedSprite2D no encontrado en chopping_state.gd")
	
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2(0,0)

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	# CORREGIR: "idle" en minúscula y verificar que animated_sprite_2d no sea null
	if animated_sprite_2d and !animated_sprite_2d.is_playing():
		transition.emit("idle")  # "idle" no "Idle"

func _on_enter() -> void:
	# Verificar que animated_sprite_2d no sea null antes de usarlo
	if animated_sprite_2d:
		if player.player_direction == Vector2.UP:
			animated_sprite_2d.play("chopping_back")
			hit_component_collision_shape.position = Vector2(0,-18)
		elif player.player_direction == Vector2.RIGHT:
			animated_sprite_2d.play("chopping_right")
			hit_component_collision_shape.position = Vector2(9,0)
		elif player.player_direction == Vector2.DOWN:
			animated_sprite_2d.play("chopping_front")
			hit_component_collision_shape.position = Vector2(0, 4)
		elif player.player_direction == Vector2.LEFT:
			animated_sprite_2d.play("chopping_left")
			hit_component_collision_shape.position = Vector2(-9,0)
		else: 
			animated_sprite_2d.play("chopping_front")
			hit_component_collision_shape.position = Vector2(0, 4)
	else:
		print("Error: animated_sprite_2d es null en chopping_state")
		
	hit_component_collision_shape.disabled = false

func _on_exit() -> void:
	# Verificar que no sea null antes de llamar stop()
	if animated_sprite_2d:
		animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
