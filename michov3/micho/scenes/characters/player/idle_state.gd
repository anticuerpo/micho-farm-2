extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

# Añadir la misma lógica de _ready()
func _ready():
	if not animated_sprite_2d:
		if player and player.has_node("AnimatedSprite2D"):
			animated_sprite_2d = player.get_node("AnimatedSprite2D")
		elif has_node("AnimatedSprite2D"):
			animated_sprite_2d = get_node("AnimatedSprite2D")
		
		if not animated_sprite_2d:
			push_warning("AnimatedSprite2D no encontrado en idle_state.gd")

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	player.velocity = Vector2.ZERO

func _on_next_transitions() -> void:
	# Transición a caminar
	if GameInputEvents.movement_input():
		transition.emit("walk")
	
	# Transición a defensa (Espacio para ahuyentar gatos)
	if Input.is_action_just_pressed("ui_accept"):
		transition.emit("defending")
	
	# Transiciones a herramientas existentes
	if GameInputEvents.use_tool():
		match player.current_tool:
			DataTypes.Tools.AxeWood:
				transition.emit("chopping")
			DataTypes.Tools.TillGround:
				transition.emit("tilling")
			DataTypes.Tools.WaterCrops:
				transition.emit("watering")

func _on_enter() -> void:
	# Reproducir animación idle según la dirección
	if animated_sprite_2d and player:
		var direction_name = player.get_facing_direction_name()
		animated_sprite_2d.play("idle_" + direction_name)

func _on_exit() -> void:
	pass
