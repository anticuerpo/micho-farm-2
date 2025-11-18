extends Node

signal score_changed(new_score: int)
signal plants_changed(current: int, max: int)
signal dirt_count_changed(count: int)
signal level_completed
signal game_over

@export var max_plants = 10
@export var max_dirt_stains = 10  # Si hay más de esto, pierdes
@export var current_level = 1
@export var win_condition = 10

var current_score = 0
var planted_count = 0
var dirt_count = 0
var plants_harvested = 0

# UI Kawaii
var score_panel
var score_label
var plants_label
var dirt_label
var score_icon
var plants_icon
var dirt_icon

func _ready():
	# Esperar un frame para que la UI esté lista
	await get_tree().process_frame
	
	# Conectar con SceneManager si existe
	if has_node("/root/SceneManager"):
		current_score = SceneManager.player_data.catnip
	
	# Crear UI kawaii
	_crear_ui_kawaii()
	
	update_score_display()
	show_level_intro()

func _crear_ui_kawaii():
	# Buscar o crear el CanvasLayer para UI
	var canvas_layer = get_tree().get_first_node_in_group("ui_layer")
	if not canvas_layer:
		canvas_layer = CanvasLayer.new()
		canvas_layer.name = "UILayer"
		canvas_layer.add_to_group("ui_layer")
		get_tree().root.add_child(canvas_layer)
	
	# Panel principal kawaii
	score_panel = Panel.new()
	if current_level == 2:
		score_panel.custom_minimum_size = Vector2(280, 140)  # Más alto para el contador de manchas
	else:
		score_panel.custom_minimum_size = Vector2(280, 100)
	score_panel.position = Vector2(20, 20)
	
	# Estilo del panel
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0.95)
	style.set_corner_radius_all(20)
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = Color(0.9, 0.75, 0.85, 0.9)
	style.shadow_size = 10
	style.shadow_color = Color(0.5, 0.7, 0.5, 0.3)
	style.shadow_offset = Vector2(0, 4)
	score_panel.add_theme_stylebox_override("panel", style)
	
	canvas_layer.add_child(score_panel)
	
	# Contenedor vertical
	var vbox = VBoxContainer.new()
	vbox.position = Vector2(15, 10)
	vbox.add_theme_constant_override("separation", 8)
	score_panel.add_child(vbox)
	
	# Fila de puntos
	var hbox_score = HBoxContainer.new()
	hbox_score.add_theme_constant_override("separation", 10)
	
	score_icon = Label.new()
	score_icon.text = "⭐"
	score_icon.add_theme_font_size_override("font_size", 24)
	hbox_score.add_child(score_icon)
	
	score_label = Label.new()
	score_label.text = "Puntos: 0"
	score_label.add_theme_font_size_override("font_size", 20)
	score_label.add_theme_color_override("font_color", Color(0.4, 0.6, 0.8))
	hbox_score.add_child(score_label)
	
	vbox.add_child(hbox_score)
	
	# Fila de plantas
	var hbox_plants = HBoxContainer.new()
	hbox_plants.add_theme_constant_override("separation", 10)
	
	plants_icon = Label.new()
	plants_icon.text = "🌸"
	plants_icon.add_theme_font_size_override("font_size", 24)
	hbox_plants.add_child(plants_icon)
	
	plants_label = Label.new()
	plants_label.text = "Plantas: 0/%d" % max_plants
	plants_label.add_theme_font_size_override("font_size", 20)
	plants_label.add_theme_color_override("font_color", Color(0.5, 0.8, 0.5))
	hbox_plants.add_child(plants_label)
	
	vbox.add_child(hbox_plants)
	
	# Fila de manchas (solo nivel 2)
	if current_level == 2:
		var hbox_dirt = HBoxContainer.new()
		hbox_dirt.add_theme_constant_override("separation", 10)
		
		dirt_icon = Label.new()
		dirt_icon.text = "💩"
		dirt_icon.add_theme_font_size_override("font_size", 24)
		hbox_dirt.add_child(dirt_icon)
		
		dirt_label = Label.new()
		dirt_label.text = "Manchas: 0/%d" % max_dirt_stains
		dirt_label.add_theme_font_size_override("font_size", 20)
		dirt_label.add_theme_color_override("font_color", Color(0.8, 0.5, 0.3))
		hbox_dirt.add_child(dirt_label)
		
		vbox.add_child(hbox_dirt)
	
	# Animación de entrada
	score_panel.modulate.a = 0
	score_panel.scale = Vector2(0.8, 0.8)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(score_panel, "modulate:a", 1.0, 0.5)
	tween.tween_property(score_panel, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func show_level_intro():
	var dialogue_scene = load("res://DialogueSystem.tscn")
	if not dialogue_scene:
		return
	
	var dialogue = dialogue_scene.instantiate()
	get_tree().root.add_child(dialogue)
	
	var dialogues = []
	
	if current_level == 1:
		dialogues = [
			{
				"character": "Micho",
				"text": "Otro día de trabajo en el jardín. Debo proteger el catnip de estos gatos traviesos."
			},
			{
				"character": "Micho",
				"text": "Si planto suficiente y los atrapo, podré ir a la tienda de Don Bigotes."
			}
		]
	else:  # Nivel 2
		dialogues = [
			{
				"character": "Micho",
				"text": "¡Este nivel es más difícil! Los gatos no solo roban, ¡también ensucian!"
			},
			{
				"character": "Micho",
				"text": "Debo limpiar las manchas antes de que haya demasiadas... Si llegan a %d, ¡perderé!" % max_dirt_stains
			}
		]
	
	dialogue.show_dialogue(dialogues)

func add_score(points: int):
	current_score += points
	plants_harvested += 1
	planted_count += 1
	
	if has_node("/root/SceneManager"):
		SceneManager.player_data.catnip = current_score
		SceneManager.player_data.plantas_plantadas = planted_count
	
	score_changed.emit(current_score)
	plants_changed.emit(planted_count, max_plants)
	
	update_score_display()
	_animar_puntos()
	
	if planted_count >= max_plants:
		check_level_completion()

func add_plant():
	planted_count += 1
	if has_node("/root/SceneManager"):
		SceneManager.player_data.plantas_plantadas = planted_count
	plants_changed.emit(planted_count, max_plants)
	update_score_display()
	
	if planted_count >= max_plants:
		check_level_completion()

func on_dirt_created():
	dirt_count += 1
	dirt_count_changed.emit(dirt_count)
	update_score_display()
	
	# Advertencia visual cuando se acerca al límite
	if dirt_count >= max_dirt_stains * 0.7:
		_animar_advertencia_manchas()
	
	if dirt_count >= max_dirt_stains:
		trigger_game_over()

func on_dirt_cleaned():
	dirt_count = max(0, dirt_count - 1)
	dirt_count_changed.emit(dirt_count)
	add_score(5)  # Bonus por limpiar

func _animar_advertencia_manchas():
	if not dirt_label:
		return
	
	var tween = create_tween()
	tween.tween_property(dirt_label, "modulate", Color(1.0, 0.3, 0.3), 0.2)
	tween.tween_property(dirt_label, "modulate", Color(0.8, 0.5, 0.3), 0.2)

func update_score_display():
	if score_label:
		score_label.text = "Puntos: %d" % current_score
	
	if plants_label:
		plants_label.text = "Plantas: %d/%d" % [planted_count, max_plants]
		
		# Cambiar color según progreso
		var progreso = float(planted_count) / max_plants
		if progreso >= 1.0:
			plants_label.add_theme_color_override("font_color", Color(1.0, 0.7, 0.3))  # Dorado
		elif progreso >= 0.5:
			plants_label.add_theme_color_override("font_color", Color(0.3, 0.8, 0.3))  # Verde brillante
		else:
			plants_label.add_theme_color_override("font_color", Color(0.5, 0.8, 0.5))  # Verde suave
	
	if dirt_label and current_level == 2:
		dirt_label.text = "Manchas: %d/%d" % [dirt_count, max_dirt_stains]
		
		# Cambiar color según peligro
		var peligro = float(dirt_count) / max_dirt_stains
		if peligro >= 0.8:
			dirt_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))  # Rojo peligro
		elif peligro >= 0.5:
			dirt_label.add_theme_color_override("font_color", Color(1.0, 0.7, 0.3))  # Naranja advertencia
		else:
			dirt_label.add_theme_color_override("font_color", Color(0.8, 0.5, 0.3))  # Marrón normal

func _animar_puntos():
	if not score_panel:
		return
	
	# Efecto de rebote
	var tween = create_tween()
	tween.tween_property(score_panel, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(score_panel, "scale", Vector2(1.0, 1.0), 0.1)
	
	# Cambiar icono temporalmente
	if score_icon:
		score_icon.text = "✨"
		await get_tree().create_timer(0.3).timeout
		score_icon.text = "⭐"
	
	# Partículas de estrellas
	_crear_particulas_puntos()

func _crear_particulas_puntos():
	if not score_panel or not score_panel.get_parent():
		return
		
	for i in range(3):
		var estrella = Label.new()
		estrella.text = ["✨", "⭐", "💫"][i % 3]
		estrella.add_theme_font_size_override("font_size", 20)
		estrella.position = score_panel.position + Vector2(140, 50)
		estrella.z_index = 100
		
		score_panel.get_parent().add_child(estrella)
		
		# Animación de partícula
		var tween = create_tween()
		tween.set_parallel(true)
		var random_x = randf_range(-30, 30)
		var random_y = randf_range(-50, -80)
		tween.tween_property(estrella, "position", estrella.position + Vector2(random_x, random_y), 0.8)
		tween.tween_property(estrella, "modulate:a", 0.0, 0.8)
		
		await tween.finished
		estrella.queue_free()

func check_level_completion():
	# Verificar si se cumplieron los objetivos
	if planted_count >= max_plants and current_score >= 50:
		trigger_level_complete()

func trigger_level_complete():
	level_completed.emit()
	_mostrar_pantalla_victoria()

func trigger_game_over():
	game_over.emit()
	_mostrar_pantalla_game_over()

func _mostrar_pantalla_victoria():
	var canvas_layer = get_tree().get_first_node_in_group("ui_layer")
	if not canvas_layer:
		return
	
	# Overlay oscuro
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.z_index = 1000
	canvas_layer.add_child(overlay)
	
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.7, 0.5)
	
	# Panel de victoria
	var victoria_panel = Panel.new()
	victoria_panel.custom_minimum_size = Vector2(450, 350)
	victoria_panel.anchor_left = 0.5
	victoria_panel.anchor_top = 0.5
	victoria_panel.anchor_right = 0.5
	victoria_panel.anchor_bottom = 0.5
	victoria_panel.offset_left = -225
	victoria_panel.offset_top = -175
	victoria_panel.offset_right = 225
	victoria_panel.offset_bottom = 175
	victoria_panel.z_index = 1001
	
	var style_victoria = StyleBoxFlat.new()
	style_victoria.bg_color = Color(1, 1, 1, 0.98)
	style_victoria.set_corner_radius_all(25)
	style_victoria.border_width_left = 4
	style_victoria.border_width_top = 4
	style_victoria.border_width_right = 4
	style_victoria.border_width_bottom = 4
	style_victoria.border_color = Color(1.0, 0.8, 0.3)
	style_victoria.shadow_size = 20
	style_victoria.shadow_color = Color(1.0, 0.8, 0.3, 0.5)
	victoria_panel.add_theme_stylebox_override("panel", style_victoria)
	
	canvas_layer.add_child(victoria_panel)
	
	# Contenido de victoria
	var vbox_victoria = VBoxContainer.new()
	vbox_victoria.anchor_right = 1.0
	vbox_victoria.anchor_bottom = 1.0
	vbox_victoria.add_theme_constant_override("separation", 15)
	victoria_panel.add_child(vbox_victoria)
	
	# Espacio
	var spacer1 = Control.new()
	spacer1.custom_minimum_size = Vector2(0, 30)
	vbox_victoria.add_child(spacer1)
	
	# Título victoria
	var titulo_victoria = Label.new()
	titulo_victoria.text = "🎉 ¡VICTORIA! 🎉"
	titulo_victoria.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo_victoria.add_theme_font_size_override("font_size", 40)
	titulo_victoria.add_theme_color_override("font_color", Color(1.0, 0.7, 0.3))
	vbox_victoria.add_child(titulo_victoria)
	
	# Mensaje
	var mensaje = Label.new()
	var texto_nivel = "Nivel %d" % current_level
	mensaje.text = "¡Has completado el %s!\n✨ Catnip ganado: %d ✨" % [texto_nivel, current_score]
	mensaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje.add_theme_font_size_override("font_size", 18)
	mensaje.add_theme_color_override("font_color", Color(0.4, 0.6, 0.4))
	vbox_victoria.add_child(mensaje)
	
	# Espacio
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 10)
	vbox_victoria.add_child(spacer2)
	
	# Botón ir a tienda
	var btn_tienda = Button.new()
	btn_tienda.text = "🏪 IR A LA TIENDA 🏪"
	btn_tienda.custom_minimum_size = Vector2(250, 50)
	btn_tienda.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_tienda.add_theme_font_size_override("font_size", 18)
	
	var style_btn_tienda = StyleBoxFlat.new()
	style_btn_tienda.bg_color = Color(0.9, 0.7, 0.9)
	style_btn_tienda.set_corner_radius_all(15)
	style_btn_tienda.border_width_left = 3
	style_btn_tienda.border_width_top = 3
	style_btn_tienda.border_width_right = 3
	style_btn_tienda.border_width_bottom = 3
	style_btn_tienda.border_color = Color(1, 1, 1, 0.8)
	btn_tienda.add_theme_stylebox_override("normal", style_btn_tienda)
	
	btn_tienda.pressed.connect(func():
		# Animación de fade out
		var fade_tween = create_tween()
		fade_tween.set_parallel(true)
		fade_tween.tween_property(overlay, "modulate:a", 0.0, 0.3)
		fade_tween.tween_property(victoria_panel, "modulate:a", 0.0, 0.3)
		await fade_tween.finished

		# Cambiar a la tienda
		get_tree().change_scene_to_file("res://scenes/tienda/tienda.tscn")
	)
	
	vbox_victoria.add_child(btn_tienda)
	
	# Botón reiniciar
	var btn_reiniciar = Button.new()
	btn_reiniciar.text = "🔄 JUGAR DE NUEVO 🔄"
	btn_reiniciar.custom_minimum_size = Vector2(250, 50)
	btn_reiniciar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_reiniciar.add_theme_font_size_override("font_size", 18)
	
	var style_btn = StyleBoxFlat.new()
	style_btn.bg_color = Color(0.6, 0.9, 0.6)
	style_btn.set_corner_radius_all(15)
	style_btn.border_width_left = 3
	style_btn.border_width_top = 3
	style_btn.border_width_right = 3
	style_btn.border_width_bottom = 3
	style_btn.border_color = Color(1, 1, 1, 0.8)
	btn_reiniciar.add_theme_stylebox_override("normal", style_btn)
	
	btn_reiniciar.pressed.connect(func():
		overlay.queue_free()
		victoria_panel.queue_free()
		await get_tree().process_frame
		get_tree().reload_current_scene()
	)
	
	vbox_victoria.add_child(btn_reiniciar)
	
	# Animación de entrada
	victoria_panel.modulate.a = 0
	victoria_panel.scale = Vector2(0.5, 0.5)
	var tween_victoria = create_tween()
	tween_victoria.set_parallel(true)
	tween_victoria.tween_property(victoria_panel, "modulate:a", 1.0, 0.5).set_delay(0.3)
	tween_victoria.tween_property(victoria_panel, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(0.3)

func _mostrar_pantalla_game_over():
	var canvas_layer = get_tree().get_first_node_in_group("ui_layer")
	if not canvas_layer:
		return
	
	# Overlay oscuro
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.z_index = 1000
	canvas_layer.add_child(overlay)
	
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.7, 0.5)
	
	# Panel de game over
	var gameover_panel = Panel.new()
	gameover_panel.custom_minimum_size = Vector2(400, 300)
	gameover_panel.anchor_left = 0.5
	gameover_panel.anchor_top = 0.5
	gameover_panel.anchor_right = 0.5
	gameover_panel.anchor_bottom = 0.5
	gameover_panel.offset_left = -200
	gameover_panel.offset_top = -150
	gameover_panel.offset_right = 200
	gameover_panel.offset_bottom = 150
	gameover_panel.z_index = 1001
	
	var style_gameover = StyleBoxFlat.new()
	style_gameover.bg_color = Color(1, 1, 1, 0.98)
	style_gameover.set_corner_radius_all(25)
	style_gameover.border_width_left = 4
	style_gameover.border_width_top = 4
	style_gameover.border_width_right = 4
	style_gameover.border_width_bottom = 4
	style_gameover.border_color = Color(0.9, 0.3, 0.3)
	style_gameover.shadow_size = 20
	style_gameover.shadow_color = Color(0.9, 0.3, 0.3, 0.5)
	gameover_panel.add_theme_stylebox_override("panel", style_gameover)
	
	canvas_layer.add_child(gameover_panel)
	
	# Contenido
	var vbox_gameover = VBoxContainer.new()
	vbox_gameover.anchor_right = 1.0
	vbox_gameover.anchor_bottom = 1.0
	vbox_gameover.add_theme_constant_override("separation", 20)
	gameover_panel.add_child(vbox_gameover)
	
	# Espacio
	var spacer1 = Control.new()
	spacer1.custom_minimum_size = Vector2(0, 30)
	vbox_gameover.add_child(spacer1)
	
	# Título game over
	var titulo_gameover = Label.new()
	titulo_gameover.text = "😿 GAME OVER 😿"
	titulo_gameover.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo_gameover.add_theme_font_size_override("font_size", 40)
	titulo_gameover.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
	vbox_gameover.add_child(titulo_gameover)
	
	# Mensaje
	var mensaje = Label.new()
	mensaje.text = "¡Demasiadas manchas!\n💩 El jardín está muy sucio 💩"
	mensaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje.add_theme_font_size_override("font_size", 18)
	mensaje.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	vbox_gameover.add_child(mensaje)
	
	# Espacio
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 20)
	vbox_gameover.add_child(spacer2)
	
	# Botón reintentar
	var btn_reintentar = Button.new()
	btn_reintentar.text = "🔄 REINTENTAR 🔄"
	btn_reintentar.custom_minimum_size = Vector2(250, 50)
	btn_reintentar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_reintentar.add_theme_font_size_override("font_size", 18)
	
	var style_btn = StyleBoxFlat.new()
	style_btn.bg_color = Color(0.9, 0.6, 0.6)
	style_btn.set_corner_radius_all(15)
	style_btn.border_width_left = 3
	style_btn.border_width_top = 3
	style_btn.border_width_right = 3
	style_btn.border_width_bottom = 3
	style_btn.border_color = Color(1, 1, 1, 0.8)
	btn_reintentar.add_theme_stylebox_override("normal", style_btn)
	
	btn_reintentar.pressed.connect(func():
		overlay.queue_free()
		gameover_panel.queue_free()
		await get_tree().process_frame
		get_tree().reload_current_scene()
	)
	
	vbox_gameover.add_child(btn_reintentar)
	
	# Animación de entrada
	gameover_panel.modulate.a = 0
	gameover_panel.scale = Vector2(0.5, 0.5)
	var tween_gameover = create_tween()
	tween_gameover.set_parallel(true)
	tween_gameover.tween_property(gameover_panel, "modulate:a", 1.0, 0.5).set_delay(0.3)
	tween_gameover.tween_property(gameover_panel, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(0.3)
