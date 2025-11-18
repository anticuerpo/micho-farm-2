extends Area2D
 
# Entrada simple a la tienda - Solo acércate y presiona E
 
@export var interior_scene: String = "res://scenes/tienda/tienda_interior.tscn"
 
var player_nearby: bool = false
var label: Label
 
func _ready():
	# Conectar señales
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
 
	# Crear label de interacción
	label = Label.new()
	label.text = "E - Entrar"
	label.position = Vector2(-30, -40)
	label.visible = false
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	add_child(label)
 
	# Verificar si está desbloqueada
	_check_unlocked()
 
func _check_unlocked():
	if has_node("/root/SceneManager"):
		if not SceneManager.player_data.shop_unlocked:
			label.text = "Cerrado"
 
func _process(_delta):
	# Si el jugador está cerca y presiona E
	if player_nearby and Input.is_action_just_pressed("interact"):
		_enter_shop()
 
func _on_body_entered(body):
	if body.is_in_group("player"):
		# Verificar si está desbloqueada
		if has_node("/root/SceneManager") and not SceneManager.player_data.shop_unlocked:
			label.text = "Cerrado"
			label.visible = true
			return
 
		player_nearby = true
		label.visible = true
		label.text = "E - Entrar"
 
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		label.visible = false
 
func _enter_shop():
	# Verificar que esté desbloqueada
	if has_node("/root/SceneManager") and not SceneManager.player_data.shop_unlocked:
		print("La tienda está cerrada")
		return
 
	print("Entrando a la tienda...")
 
	# Guardar posición para regresar
	if has_node("/root/SceneManager"):
		var player = get_tree().get_first_node_in_group("player")
		if player:
			SceneManager.player_data["last_position"] = player.global_position
			SceneManager.player_data["last_scene"] = get_tree().current_scene.scene_file_path
 
	# Cambiar a la escena interior
	get_tree().change_scene_to_file(interior_scene)
 
