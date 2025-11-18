extends StaticBody2D

# Puerta de la tienda que cambia a la escena interior

@export var interior_scene_path: String = "res://scenes/tienda/tienda_interior.tscn"
@export var spawn_position: String = "SpawnPoint"  # Nombre del nodo donde aparecerá el jugador

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: InteractableComponent = $InteractableComponent
@onready var interaction_label: Label = $InteractionLabel

var player_nearby: bool = false
var is_shop_unlocked: bool = true  # Se desbloqueará después del nivel 1

func _ready():
	# Conectar señales
	interactable.interactable_activated.connect(_on_player_entered)
	interactable.interactable_deactivated.connect(_on_player_exited)

	# Configurar label de interacción
	if not has_node("InteractionLabel"):
		interaction_label = Label.new()
		interaction_label.name = "InteractionLabel"
		interaction_label.position = Vector2(-30, -40)
		add_child(interaction_label)

	interaction_label.visible = false
	interaction_label.add_theme_font_size_override("font_size", 12)
	interaction_label.add_theme_color_override("font_color", Color.WHITE)
	interaction_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	interaction_label.add_theme_constant_override("shadow_offset_x", 1)
	interaction_label.add_theme_constant_override("shadow_offset_y", 1)

	# Verificar si la tienda está desbloqueada
	_check_shop_status()

	# Play default animation
	if animated_sprite:
		animated_sprite.play("default")

func _check_shop_status():
	# Verificar en SceneManager si la tienda está desbloqueada
	if has_node("/root/SceneManager"):
		is_shop_unlocked = SceneManager.player_data.get("shop_unlocked", false)

	# Actualizar el texto del label
	if is_shop_unlocked:
		interaction_label.text = "E - Entrar a la tienda"
	else:
		interaction_label.text = "Cerrado"

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("interact"):
		if is_shop_unlocked:
			_enter_shop()
		else:
			_show_locked_message()

func _on_player_entered():
	player_nearby = true
	interaction_label.visible = true

	if animated_sprite and animated_sprite.sprite_frames.has_animation("open_door"):
		animated_sprite.play("open_door")

func _on_player_exited():
	player_nearby = false
	interaction_label.visible = false

	if animated_sprite and animated_sprite.sprite_frames.has_animation("close_door"):
		animated_sprite.play("close_door")

func _enter_shop():
	print("Entrando a la tienda...")

	# Guardar la posición actual del jugador (por si queremos regresar)
	var player = get_tree().get_first_node_in_group("player")
	if player and has_node("/root/SceneManager"):
		SceneManager.player_data["last_position"] = player.global_position
		SceneManager.player_data["last_scene"] = get_tree().current_scene.scene_file_path

	# Cambiar a la escena interior
	get_tree().change_scene_to_file(interior_scene_path)

func _show_locked_message():
	# Mostrar mensaje de que está cerrada
	var label = Label.new()
	label.text = "La tienda aún está cerrada"
	label.position = Vector2(-60, -60)
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color.ORANGE_RED)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	add_child(label)

	# Eliminar el mensaje después de 2 segundos
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(label):
		label.queue_free()
