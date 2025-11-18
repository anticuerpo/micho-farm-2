class_name Player
extends CharacterBody2D
@onready var particulas = $ParticulasPisadas  # Asegúrate del nombre correcto
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var plant_scene: PackedScene  # Asigna la escena de la planta en el inspector
var intentos_ahuyentar = 0  # Contador
var dialogo_mostrado = false  # Para que no se repita infinitamente

var player_direction: Vector2 = Vector2.DOWN
var is_interacting: bool = false
var interaction_cooldown: float = 0.3  # Segundos entre interacciones
var last_interaction_time: float = 0.0
var scare_radius: float = 150.0  # Radio para ahuyentar enemigos
var scare_cooldown: float = 1.0  # Tiempo entre ahuyentamientos
var last_scare_time: float = 0.0

func _ready():
	add_to_group("player")

func _input(event):
	# Plantar/Cosechar con clic izquierdo
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		attempt_plant_interaction()
	
	# Ahuyentar enemigos con ESPACIO
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		attempt_scare_enemies()
		
	if event.is_action_pressed("ui_cancel"):  # Tecla ESC
		get_tree().change_scene_to_file("res://main_menu.tscn")

func _process(delta):
	# Actualizar el cooldown
	if last_interaction_time > 0:
		last_interaction_time -= delta
	if last_scare_time > 0:
		last_scare_time -= delta
	if velocity.length() > 10:
		particulas.emitting = true
	else:
		particulas.emitting = false

# Ahuyentar enemigos con ESPACIO
func attempt_scare_enemies():
	var current_time = Time.get_unix_time_from_system()
	if current_time - last_scare_time < scare_cooldown:
		print("Espera para ahuyentar de nuevo")
		return
	
	print("¡Intentando ahuyentar enemigos!")
	last_scare_time = current_time
	
	
	# Mostrar efecto visual del grito
	show_scare_effect()
	
	# Buscar todos los enemigos en el grupo "enemies"
	var enemies = get_tree().get_nodes_in_group("enemies")
	var enemies_scared = 0
	
	for enemy in enemies:
		if is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if distance <= scare_radius:
				print("Ahuyentando enemigo a distancia: ", distance)
				if enemy.has_method("scare_away"):
					enemy.scare_away(global_position)
					enemies_scared += 1
	if enemies_scared > 0:
		print("¡Ahuyentados ", enemies_scared, " enemigos!")
		# Contador de intentos
		intentos_ahuyentar += 1
		print("Intentos de ahuyentar: ", intentos_ahuyentar)
		
		if intentos_ahuyentar >= 3 and not dialogo_mostrado:
			mostrar_dialogo_5_intentos()
	else:
		print("No hay enemigos cerca para ahuyentar")
# Efecto visual simple para el grito - SOLUCIÓN RÁPIDA
func show_scare_effect():
	# Crear una onda de choque visual
	var shockwave = ColorRect.new()
	shockwave.name = "ScareShockwave"
	shockwave.color = Color(1, 1, 1, 0.5)  # Blanco semi-transparente
	shockwave.size = Vector2(10, 10)
	shockwave.position = -Vector2(10, 10)  # Centrado en el jugador
	shockwave.z_index = 100  # Alto para asegurar que se vea
	
	# Hacer el ColorRect circular
	shockwave.material = ShaderMaterial.new()
	var shader_code = """
	shader_type canvas_item;
	void fragment() {
		vec2 center = vec2(0.5, 0.5);
		float dist = distance(UV, center);
		if (dist > 0.5) {
			COLOR = vec4(0.0);
		} else {
			COLOR = COLOR;
		}
	}
	"""
	shockwave.material.shader = Shader.new()
	shockwave.material.shader.code = shader_code
	
	add_child(shockwave)
	
	# Animación de la onda expansiva
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Expansión
	tween.tween_property(shockwave, "size", Vector2(scare_radius * 2, scare_radius * 2), 0.6)
	tween.tween_property(shockwave, "position", -Vector2(scare_radius, scare_radius), 0.6)
	
	# Desvanecimiento
	tween.tween_property(shockwave, "color:a", 0.0, 0.6)
	
	# Efecto de pulso adicional (opcional)
	var pulse_tween = create_tween()
	pulse_tween.tween_property(shockwave, "color", Color(1, 0.8, 0.3, 0.7), 0.1)
	pulse_tween.tween_property(shockwave, "color", Color(0.694, 0.369, 0.918, 0.502), 0.1)
	
	# Eliminar después de la animación
	tween.tween_callback(shockwave.queue_free).set_delay(0.6)
	
	print("¡Efecto visual de grito activado!")

# Interacción con plantas mediante clic en el mundo
func attempt_plant_interaction():
	# Verificar cooldown para evitar interacciones rápidas
	var current_time = Time.get_unix_time_from_system()
	if current_time - last_interaction_time < interaction_cooldown:
		return
	
	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	
	# Raycast desde el mouse para detectar si hay algo en esa posición
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	query.collision_mask = 4  # Layer para plantas/terreno
	
	var result = space_state.intersect_point(query, 1)
	
	# Verificar distancia para interactuar
	var distance = global_position.distance_to(mouse_pos)
	if distance > 100:  # Radio de interacción
		print("Demasiado lejos para interactuar")
		return
	
	if result.size() > 0:
		var clicked = result[0].collider
		
		# Verificar si es una planta del jardín
		if clicked.is_in_group("plants") and clicked.has_method("interact"):
			# Verificar si tenemos la herramienta correcta
			if can_interact_with_plant(clicked):
				clicked.interact()
				last_interaction_time = current_time
			else:
				print("Herramienta incorrecta para esta interacción")
	else:
		# Si no hay nada, plantar una nueva planta
		plant_new_plant(mouse_pos)
		last_interaction_time = current_time

# Verificar si podemos interactuar con la planta según la herramienta
func can_interact_with_plant(plant) -> bool:
	# Si la planta necesita una herramienta específica, verificamos aquí
	# Por ejemplo, si tiene un método para obtener la herramienta requerida
	if plant.has_method("get_required_tool"):
		var required_tool = plant.get_required_tool()
		return current_tool == required_tool
	
	# Para plantar nuevas plantas, no necesitamos herramienta
	# Para cosechar, podríamos necesitar una herramienta específica
	# Esta lógica puede expandirse según tus necesidades
	return current_tool == DataTypes.Tools.None

func plant_new_plant(position: Vector2):
	if plant_scene and current_tool == DataTypes.Tools.None:
		var new_plant = plant_scene.instantiate()
		get_parent().add_child(new_plant)  # Agregar al nivel, no al jugador
		new_plant.global_position = position
		new_plant.interact()  # Esto plantará la semilla
		print("Nueva planta creada en: ", position)
	else:
		print("No se puede plantar - verifica plant_scene y herramienta")

func get_facing_direction_name() -> String:
	if player_direction == Vector2.UP:
		return "back"
	elif player_direction == Vector2.DOWN:
		return "front"
	elif player_direction == Vector2.LEFT:
		return "left"
	elif player_direction == Vector2.RIGHT:
		return "right"
	return "front"

# Método para cambiar herramienta (puedes llamar esto desde UI)
func set_tool(new_tool: DataTypes.Tools):
	current_tool = new_tool
	print("Herramienta cambiada a: ", DataTypes.Tools.keys()[new_tool])

# Método para obtener la herramienta actual
func get_current_tool() -> DataTypes.Tools:
	return current_tool
func mostrar_dialogo_5_intentos():
	mostrar_burbuja_bonita("¡Ya van 4 veces que espanto a estos bichos!")
	intentos_ahuyentar = 0

func mostrar_burbuja_bonita(texto: String):
	# Panel de fondo (la burbuja) - MÁS PEQUEÑA
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(120, 40)
	panel.position = Vector2(-60, -60)
	
	# Estilo del panel
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(1, 1, 1, 0.95)
	stylebox.border_color = Color(0.2, 0.2, 0.2, 1)
	
	# Bordes individuales en lugar de border_width_all
	stylebox.set_border_width(SIDE_LEFT, 2)
	stylebox.set_border_width(SIDE_TOP, 2)
	stylebox.set_border_width(SIDE_RIGHT, 2)
	stylebox.set_border_width(SIDE_BOTTOM, 2)
	
	# Esquinas redondeadas
	stylebox.set_corner_radius(CORNER_TOP_LEFT, 8)
	stylebox.set_corner_radius(CORNER_TOP_RIGHT, 8)
	stylebox.set_corner_radius(CORNER_BOTTOM_LEFT, 8)
	stylebox.set_corner_radius(CORNER_BOTTOM_RIGHT, 8)
	
	# Márgenes
	stylebox.content_margin_left = 8
	stylebox.content_margin_right = 8
	stylebox.content_margin_top = 6
	stylebox.content_margin_bottom = 6
	
	panel.add_theme_stylebox_override("panel", stylebox)
	add_child(panel)
	
	# Texto
	var label = Label.new()
	label.text = texto
	label.add_theme_font_size_override("font_size", 9)
	label.add_theme_color_override("font_color", Color(0, 0, 0, 1))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.custom_minimum_size = Vector2(104, 28)
	label.position = Vector2(8, 6)
	
	panel.add_child(label)
	
	# Animación
	panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)
	
	await get_tree().create_timer(2.5).timeout
	
	var tween2 = create_tween()
	tween2.tween_property(panel, "modulate:a", 0.0, 0.3)
	await tween2.finished
	
	panel.queue_free()
