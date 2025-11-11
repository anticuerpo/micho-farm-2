extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

func _ready():
	if not animated_sprite_2d:
		if player and player.has_node("AnimatedSprite2D"):
			animated_sprite_2d = player.get_node("AnimatedSprite2D")
		elif has_node("AnimatedSprite2D"):
			animated_sprite_2d = get_node("AnimatedSprite2D")
		
		if not animated_sprite_2d:
			push_warning("AnimatedSprite2D no encontrado en watering_state.gd")

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if animated_sprite_2d and !animated_sprite_2d.is_playing():
		transition.emit("idle")  # "idle" en minúscula

func _on_enter() -> void:
	if animated_sprite_2d:
		if player.player_direction == Vector2.UP:
			animated_sprite_2d.play("watering_back")
		elif player.player_direction == Vector2.RIGHT:
			animated_sprite_2d.play("watering_right")
		elif player.player_direction == Vector2.DOWN:
			animated_sprite_2d.play("watering_front")
		elif player.player_direction == Vector2.LEFT:
			animated_sprite_2d.play("watering_left")
		else: 
			animated_sprite_2d.play("watering_front")
	else:
		print("Error: animated_sprite_2d es null en watering_state")

func _on_exit() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.stop()
