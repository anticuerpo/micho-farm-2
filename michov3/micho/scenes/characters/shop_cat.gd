extends CharacterBody2D

# NPC Gatito de la tienda - Don Bigotes

@onready var animated_sprite: AnimatedSprite2D = $Sprite2D
@onready var interactable: InteractableComponent = $InteractableComponent
@onready var interaction_label: Label = $InteractionLabel

var player_nearby: bool = false

func _ready():
	# Conectar señales de interacción
	interactable.interactable_activated.connect(_on_player_entered)
	interactable.interactable_deactivated.connect(_on_player_exited)

	# Ocultar label de interacción
	interaction_label.visible = false
	interaction_label.text = "E - Hablar"
	interaction_label.add_theme_font_size_override("font_size", 12)
	interaction_label.add_theme_color_override("font_color", Color.WHITE)
	interaction_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	interaction_label.add_theme_constant_override("shadow_offset_x", 1)
	interaction_label.add_theme_constant_override("shadow_offset_y", 1)

	# Play idle animation
	if animated_sprite and animated_sprite.sprite_frames.has_animation("idle"):
		animated_sprite.play("idle")

func _process(_delta):
	# Si el jugador está cerca y presiona E, abrir tienda
	if player_nearby and Input.is_action_just_pressed("interact"):
		_open_shop()

func _on_player_entered():
	player_nearby = true
	interaction_label.visible = true
	print("Gatito: ¡Hola! Presiona E para ver mis productos")

func _on_player_exited():
	player_nearby = false
	interaction_label.visible = false

func _open_shop():
	print("Abriendo diálogo de tienda...")

	# Primero mostrar el diálogo
	if has_node("/root/Dialogic"):
		var dialogo = Dialogic.start("tienda_dialogo")

		# Cuando termine el diálogo, abrir la tienda
		dialogo.timeline_ended.connect(_abrir_ui_tienda)
	else:
		# Si no hay Dialogic, abrir directamente
		_abrir_ui_tienda()

func _abrir_ui_tienda():
	print("Abriendo UI de tienda...")

	# Crear la UI de tienda como overlay
	var shop_ui_scene = load("res://scenes/tienda/tienda_ui.tscn")
	if shop_ui_scene:
		var shop_ui = shop_ui_scene.instantiate()
		get_tree().root.add_child(shop_ui)
	else:
		push_error("No se pudo cargar la escena tienda_ui.tscn")
