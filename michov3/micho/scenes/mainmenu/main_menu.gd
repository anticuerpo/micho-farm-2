
extends Control

func _ready():
	# Configurar que este Control ocupe toda la pantalla
	size = get_viewport_rect().size
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	# Fondo 
	var fondo = ColorRect.new()
	fondo.anchor_right = 1.0
	fondo.anchor_bottom = 1.0
	fondo.color = Color(0.85, 0.95, 0.85)  # Verde pastel suave
	add_child(fondo)
	
	# Añadir decoraciones de fondo (nubes)
	_crear_decoraciones_fondo()
	
	# Panel principal 
	var panel_central = Panel.new()
	panel_central.anchor_left = 0.5
	panel_central.anchor_top = 0.5
	panel_central.anchor_right = 0.5
	panel_central.anchor_bottom = 0.5
	panel_central.offset_left = -250
	panel_central.offset_top = -280
	panel_central.offset_right = 250
	panel_central.offset_bottom = 280
	panel_central.add_theme_stylebox_override("panel", _crear_panel_kawaii())
	add_child(panel_central)
	
	# Contenedor vertical para organizar elementos
	var vbox = VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.add_theme_constant_override("separation", 25)
	panel_central.add_child(vbox)
	
	# Espacio superior
	vbox.add_child(_crear_spacer(40))
	
	# Título con efecto 
	var titulo_container = VBoxContainer.new()
	titulo_container.add_theme_constant_override("separation", 5)
	
	var titulo = Label.new()
	titulo.text = "🌸 MICHO'S FARM 🌸"
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 48)
	titulo.add_theme_color_override("font_color", Color(0.4, 0.7, 0.4))
	titulo_container.add_child(titulo)
	
	var subtitulo = Label.new()
	subtitulo.text = "✿ Una aventura de jardinería ✿"
	subtitulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitulo.add_theme_font_size_override("font_size", 16)
	subtitulo.add_theme_color_override("font_color", Color(0.5, 0.8, 0.5, 0.8))
	titulo_container.add_child(subtitulo)
	
	vbox.add_child(titulo_container)
	
	# Espacio
	vbox.add_child(_crear_spacer(50))
	
	# Contenedor de botones centrado
	var botones_container = VBoxContainer.new()
	botones_container.add_theme_constant_override("separation", 20)
	botones_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	# Botón Iniciar Juego (kawaii)
	var btn_iniciar = _crear_boton_kawaii("🌱 INICIAR JUEGO 🌱", Color(0.6, 0.9, 0.6))
	btn_iniciar.pressed.connect(_on_start_pressed)
	botones_container.add_child(btn_iniciar)
	
	# Botón Tienda
	var btn_tienda = _crear_boton_kawaii("🏪 TIENDA 🏪", Color(0.9, 0.7, 0.9))
	btn_tienda.pressed.connect(_on_tienda_pressed)
	botones_container.add_child(btn_tienda)

	# Botón Opciones (opcional, cute)
	var btn_opciones = _crear_boton_kawaii("⚙️ OPCIONES", Color(0.9, 0.85, 0.6))
	btn_opciones.pressed.connect(_on_opciones_pressed)
	botones_container.add_child(btn_opciones)

	# Botón Salir (suave)
	var btn_salir = _crear_boton_kawaii("🌙 SALIR", Color(0.95, 0.8, 0.85))
	btn_salir.pressed.connect(_on_exit_pressed)
	botones_container.add_child(btn_salir)
	
	vbox.add_child(botones_container)
	
	# Espacio inferior
	vbox.add_child(_crear_spacer(40))
	
	# Texto decorativo abajo
	var texto_pie = Label.new()
	texto_pie.text = "♡ Hecho por Lou ♡"
	texto_pie.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto_pie.add_theme_font_size_override("font_size", 14)
	texto_pie.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6, 0.6))
	vbox.add_child(texto_pie)
	
	# Animación de entrada
	_animar_entrada(panel_central)

func _crear_decoraciones_fondo():
	# Crear elementos decorativos kawaii en el fondo
	
	# Nubes kawaii
	for i in range(4):
		var nube = _crear_nube()
		nube.position = Vector2(randf() * 1000, randf() * 300 + 50)
		add_child(nube)
		
		# Animación flotante
		var tween = create_tween().set_loops()
		tween.tween_property(nube, "position:y", nube.position.y + 20, 3.0 + randf() * 2.0)
		tween.tween_property(nube, "position:y", nube.position.y, 3.0 + randf() * 2.0)
	
	# Flores decorativas en las esquinas
	_crear_flores_esquinas()

func _crear_nube() -> Control:
	var nube = Control.new()
	nube.custom_minimum_size = Vector2(100, 50)
	
	# Círculos que forman la nube
	for i in range(3):
		var circulo = ColorRect.new()
		circulo.color = Color(1, 1, 1, 0.4)
		circulo.custom_minimum_size = Vector2(40 + randf() * 30, 40 + randf() * 20)
		circulo.position = Vector2(i * 25, randf() * 10)
		
		# Hacer circular con shader o simplemente dejar rectangular suave
		var style = StyleBoxFlat.new()
		style.bg_color = Color(1, 1, 1, 0.5)
		style.set_corner_radius_all(20)
		
		nube.add_child(circulo)
	
	return nube

func _crear_flores_esquinas():
	# Flores en esquina superior izquierda
	for i in range(3):
		var flor = Label.new()
		flor.text = ["🌸", "🌼", "🌺"][i]
		flor.add_theme_font_size_override("font_size", 32)
		flor.position = Vector2(20 + i * 50, 20 + i * 30)
		add_child(flor)
	
	# Flores en esquina inferior derecha
	for i in range(3):
		var flor = Label.new()
		flor.text = ["🌻", "🌷", "🌹"][i]
		flor.add_theme_font_size_override("font_size", 32)
		flor.position = Vector2(900 - i * 50, 650 - i * 30)
		add_child(flor)

func _crear_panel_kawaii() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0.95)
	style.set_corner_radius_all(25)
	
	# Borde suave
	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.border_color = Color(0.9, 0.75, 0.85, 0.8)
	
	# Sombra suave
	style.shadow_size = 15
	style.shadow_color = Color(0.5, 0.7, 0.5, 0.3)
	style.shadow_offset = Vector2(0, 5)
	
	# Padding
	style.content_margin_left = 30
	style.content_margin_top = 30
	style.content_margin_right = 30
	style.content_margin_bottom = 30
	
	return style

func _crear_boton_kawaii(texto: String, color: Color) -> Button:
	var btn = Button.new()
	btn.text = texto
	btn.custom_minimum_size = Vector2(300, 60)
	btn.add_theme_font_size_override("font_size", 20)
	btn.add_theme_color_override("font_color", Color(0.3, 0.5, 0.3))
	btn.add_theme_color_override("font_hover_color", Color(0.2, 0.4, 0.2))
	
	# Estilo normal
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = color
	style_normal.set_corner_radius_all(20)
	style_normal.border_width_left = 3
	style_normal.border_width_top = 3
	style_normal.border_width_right = 3
	style_normal.border_width_bottom = 3
	style_normal.border_color = Color(1, 1, 1, 0.8)
	style_normal.shadow_size = 5
	style_normal.shadow_color = Color(0, 0, 0, 0.2)
	style_normal.shadow_offset = Vector2(0, 3)
	btn.add_theme_stylebox_override("normal", style_normal)
	
	# Estilo hover (más brillante)
	var style_hover = style_normal.duplicate()
	style_hover.bg_color = color.lightened(0.15)
	style_hover.shadow_size = 8
	btn.add_theme_stylebox_override("hover", style_hover)
	
	# Estilo pressed (más oscuro)
	var style_pressed = style_normal.duplicate()
	style_pressed.bg_color = color.darkened(0.1)
	style_pressed.shadow_size = 2
	style_pressed.shadow_offset = Vector2(0, 1)
	btn.add_theme_stylebox_override("pressed", style_pressed)
	
	# Efecto hover con animación
	btn.mouse_entered.connect(func(): _animar_boton_hover(btn))
	btn.mouse_exited.connect(func(): _animar_boton_salida(btn))
	
	return btn

func _crear_spacer(altura: float) -> Control:
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, altura)
	return spacer

func _animar_entrada(panel: Control):
	# Animación de entrada suave
	panel.modulate.a = 0
	panel.scale = Vector2(0.8, 0.8)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.5)
	tween.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _animar_boton_hover(boton: Button):
	var tween = create_tween()
	tween.tween_property(boton, "scale", Vector2(1.05, 1.05), 0.1)

func _animar_boton_salida(boton: Button):
	var tween = create_tween()
	tween.tween_property(boton, "scale", Vector2(1.0, 1.0), 0.1)

func _on_start_pressed():
	print("🌱 Iniciando juego...")
	
	# Animación de salida
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")

func _on_tienda_pressed():
	print("🏪 Abriendo tienda...")

	# Dar algo de catnip para probar la tienda
	if has_node("/root/SceneManager"):
		if SceneManager.player_data.catnip == 0:
			SceneManager.player_data.catnip = 200  # Dinero inicial para probar

	# Animación de salida
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/tienda/tienda.tscn")

func _on_opciones_pressed():
	print("⚙️ Abriendo opciones...")
	# Aquí el menu
	var label_temp = Label.new()
	label_temp.text = "✨ Opciones (próximamente) ✨"
	label_temp.position = Vector2(400, 350)
	label_temp.add_theme_font_size_override("font_size", 24)
	add_child(label_temp)

	await get_tree().create_timer(1.5).timeout
	label_temp.queue_free()

func _on_exit_pressed():
	print("🌙 Saliendo del juego...")
	
	# Animación de salida
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		size = get_viewport_rect().size
