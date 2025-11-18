extends Node2D

# Tienda de Don Bigotes - Compra de mejoras kawaii

var ui_layer: CanvasLayer
var main_container: Control
var money_label: Label
var shop_items: Array = []

# Precios de mejoras
var mejoras_config = {
	"velocidad": {
		"nombre": "Botas Rápidas",
		"descripcion": "Aumenta tu velocidad",
		"precio_base": 50,
		"incremento": 1.5,
		"max_nivel": 5,
		"emoji": "⚡",
		"color": Color(0.9, 0.85, 0.6)  # Amarillo pastel
	},
	"capacidad_bolsa": {
		"nombre": "Bolsa Grande",
		"descripcion": "Aumenta tu capacidad",
		"precio_base": 75,
		"incremento": 1.4,
		"max_nivel": 5,
		"emoji": "🎒",
		"color": Color(0.85, 0.9, 0.95)  # Azul pastel
	}
}

func _ready():
	# Crear la UI de la tienda
	_crear_ui_tienda()

	# Actualizar display de dinero
	_actualizar_dinero()

	# Reproducir música de tienda si existe
	if AudioManager:
		AudioManager.play_music("1_new_life_master")

func _crear_ui_tienda():
	# Crear CanvasLayer para la UI
	ui_layer = CanvasLayer.new()
	ui_layer.layer = 100
	add_child(ui_layer)

	# Contenedor principal que ocupa toda la pantalla
	main_container = Control.new()
	main_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_layer.add_child(main_container)

	# Fondo de color kawaii
	var fondo = ColorRect.new()
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo.color = Color(0.9, 0.85, 0.95)  # Morado/rosa pastel suave
	main_container.add_child(fondo)

	# Decoraciones de fondo
	_crear_decoraciones()

	# Panel principal de la tienda
	var shop_panel = Panel.new()
	shop_panel.custom_minimum_size = Vector2(700, 550)
	shop_panel.set_anchors_preset(Control.PRESET_CENTER)
	shop_panel.position = Vector2(-350, -275)
	shop_panel.add_theme_stylebox_override("panel", _crear_panel_kawaii())
	main_container.add_child(shop_panel)

	# Contenedor vertical para organizar todo
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 20)
	shop_panel.add_child(vbox)

	# Espacio superior
	vbox.add_child(_crear_spacer(20))

	# Header de la tienda
	_crear_header(vbox)

	# Panel de dinero
	_crear_panel_dinero(vbox)

	vbox.add_child(_crear_spacer(10))

	# Mensaje de bienvenida
	var mensaje = Label.new()
	mensaje.text = "Bienvenido a la tienda"
	mensaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje.add_theme_font_size_override("font_size", 18)
	mensaje.add_theme_color_override("font_color", Color(0.5, 0.4, 0.6))
	vbox.add_child(mensaje)

	vbox.add_child(_crear_spacer(15))

	# Contenedor de items de la tienda
	var items_container = VBoxContainer.new()
	items_container.add_theme_constant_override("separation", 15)
	items_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(items_container)

	# Crear items de mejora
	_crear_item_mejora(items_container, "velocidad")
	_crear_item_mejora(items_container, "capacidad_bolsa")

	vbox.add_child(_crear_spacer(20))

	# Botón de salir
	var btn_salir = _crear_boton_kawaii("VOLVER AL MENÚ", Color(0.95, 0.8, 0.85))
	btn_salir.pressed.connect(_on_salir_pressed)
	btn_salir.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(btn_salir)

	vbox.add_child(_crear_spacer(20))

	# Animación de entrada
	_animar_entrada(shop_panel)

func _crear_header(parent: Control):
	var header_container = VBoxContainer.new()
	header_container.add_theme_constant_override("separation", 5)

	var titulo = Label.new()
	titulo.text = "TIENDA"
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 42)
	titulo.add_theme_color_override("font_color", Color(0.5, 0.3, 0.6))
	header_container.add_child(titulo)

	var subtitulo = Label.new()
	subtitulo.text = "Mejora tus habilidades"
	subtitulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitulo.add_theme_font_size_override("font_size", 16)
	subtitulo.add_theme_color_override("font_color", Color(0.6, 0.5, 0.7, 0.8))
	header_container.add_child(subtitulo)

	parent.add_child(header_container)

func _crear_panel_dinero(parent: Control):
	var money_panel = Panel.new()
	money_panel.custom_minimum_size = Vector2(250, 70)
	money_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.95, 0.95, 0.7, 0.9)  # Amarillo suave
	style.set_corner_radius_all(15)
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = Color(1, 1, 1, 0.9)
	style.shadow_size = 8
	style.shadow_color = Color(0.4, 0.5, 0.4, 0.3)
	style.shadow_offset = Vector2(0, 3)
	money_panel.add_theme_stylebox_override("panel", style)

	var hbox = HBoxContainer.new()
	hbox.position = Vector2(20, 15)
	hbox.add_theme_constant_override("separation", 15)

	var icon = Label.new()
	icon.text = "🌿"
	icon.add_theme_font_size_override("font_size", 36)
	hbox.add_child(icon)

	money_label = Label.new()
	money_label.text = "0 Catnip"
	money_label.add_theme_font_size_override("font_size", 28)
	money_label.add_theme_color_override("font_color", Color(0.4, 0.6, 0.3))
	hbox.add_child(money_label)

	money_panel.add_child(hbox)
	parent.add_child(money_panel)

func _crear_item_mejora(parent: Control, tipo_mejora: String):
	var config = mejoras_config[tipo_mejora]
	var nivel_actual = _obtener_nivel_actual(tipo_mejora)
	var precio_actual = _calcular_precio(tipo_mejora, nivel_actual)

	# Panel del item
	var item_panel = Panel.new()
	item_panel.custom_minimum_size = Vector2(650, 100)

	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0.95)
	style.set_corner_radius_all(20)
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.border_color = config.color
	style.shadow_size = 6
	style.shadow_color = Color(0.5, 0.5, 0.5, 0.2)
	style.shadow_offset = Vector2(0, 2)
	item_panel.add_theme_stylebox_override("panel", style)

	# HBox principal
	var hbox = HBoxContainer.new()
	hbox.position = Vector2(20, 20)
	hbox.add_theme_constant_override("separation", 20)

	# Emoji grande
	var emoji_label = Label.new()
	emoji_label.text = config.emoji
	emoji_label.add_theme_font_size_override("font_size", 48)
	hbox.add_child(emoji_label)

	# Info de la mejora
	var info_vbox = VBoxContainer.new()
	info_vbox.add_theme_constant_override("separation", 5)
	info_vbox.custom_minimum_size = Vector2(280, 0)

	var nombre_label = Label.new()
	nombre_label.text = config.nombre
	nombre_label.add_theme_font_size_override("font_size", 22)
	nombre_label.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3))
	info_vbox.add_child(nombre_label)

	var desc_label = Label.new()
	desc_label.text = config.descripcion
	desc_label.add_theme_font_size_override("font_size", 14)
	desc_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	info_vbox.add_child(desc_label)

	var nivel_label = Label.new()
	nivel_label.name = "NivelLabel"
	if nivel_actual >= config.max_nivel:
		nivel_label.text = "NIVEL MÁXIMO"
		nivel_label.add_theme_color_override("font_color", Color(1.0, 0.7, 0.3))
	else:
		nivel_label.text = "Nivel: %d/%d" % [nivel_actual, config.max_nivel]
		nivel_label.add_theme_color_override("font_color", Color(0.4, 0.6, 0.8))
	nivel_label.add_theme_font_size_override("font_size", 14)
	info_vbox.add_child(nivel_label)

	hbox.add_child(info_vbox)

	# Espaciador flexible
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(spacer)

	# Botón de compra
	var btn_comprar = _crear_boton_compra(tipo_mejora, precio_actual, nivel_actual >= config.max_nivel)
	btn_comprar.name = "BtnComprar"
	hbox.add_child(btn_comprar)

	item_panel.add_child(hbox)
	parent.add_child(item_panel)

	# Guardar referencia
	shop_items.append({
		"tipo": tipo_mejora,
		"panel": item_panel,
		"boton": btn_comprar,
		"nivel_label": nivel_label
	})

func _crear_boton_compra(tipo_mejora: String, precio: int, max_nivel: bool) -> Button:
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(160, 60)

	if max_nivel:
		btn.text = "MÁXIMO"
		btn.disabled = true
		btn.add_theme_font_size_override("font_size", 16)

		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.7, 0.7, 0.7, 0.5)
		style.set_corner_radius_all(15)
		btn.add_theme_stylebox_override("normal", style)
		btn.add_theme_stylebox_override("disabled", style)
	else:
		btn.text = "%d\nComprar" % precio
		btn.add_theme_font_size_override("font_size", 16)
		btn.add_theme_color_override("font_color", Color(0.3, 0.5, 0.3))

		# Estilo normal
		var style_normal = StyleBoxFlat.new()
		style_normal.bg_color = Color(0.7, 0.9, 0.7)
		style_normal.set_corner_radius_all(15)
		style_normal.border_width_left = 3
		style_normal.border_width_top = 3
		style_normal.border_width_right = 3
		style_normal.border_width_bottom = 3
		style_normal.border_color = Color(1, 1, 1, 0.8)
		style_normal.shadow_size = 5
		style_normal.shadow_color = Color(0, 0, 0, 0.2)
		style_normal.shadow_offset = Vector2(0, 3)
		btn.add_theme_stylebox_override("normal", style_normal)

		# Estilo hover
		var style_hover = style_normal.duplicate()
		style_hover.bg_color = Color(0.7, 0.9, 0.7).lightened(0.15)
		style_hover.shadow_size = 8
		btn.add_theme_stylebox_override("hover", style_hover)

		# Estilo pressed
		var style_pressed = style_normal.duplicate()
		style_pressed.bg_color = Color(0.7, 0.9, 0.7).darkened(0.1)
		style_pressed.shadow_size = 2
		btn.add_theme_stylebox_override("pressed", style_pressed)

		# Conectar señal
		btn.pressed.connect(_on_comprar_mejora.bind(tipo_mejora))

		# Animaciones hover
		btn.mouse_entered.connect(func(): _animar_boton_hover(btn))
		btn.mouse_exited.connect(func(): _animar_boton_salida(btn))

	return btn

func _crear_decoraciones():
	# Sin decoraciones para mantener la UI limpia
	pass

func _crear_panel_kawaii() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0.98)
	style.set_corner_radius_all(25)

	style.border_width_left = 4
	style.border_width_top = 4
	style.border_width_right = 4
	style.border_width_bottom = 4
	style.border_color = Color(0.85, 0.75, 0.9, 0.9)

	style.shadow_size = 20
	style.shadow_color = Color(0.4, 0.3, 0.5, 0.4)
	style.shadow_offset = Vector2(0, 8)

	style.content_margin_left = 30
	style.content_margin_top = 30
	style.content_margin_right = 30
	style.content_margin_bottom = 30

	return style

func _crear_boton_kawaii(texto: String, color: Color) -> Button:
	var btn = Button.new()
	btn.text = texto
	btn.custom_minimum_size = Vector2(280, 55)
	btn.add_theme_font_size_override("font_size", 18)
	btn.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3))

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

	var style_hover = style_normal.duplicate()
	style_hover.bg_color = color.lightened(0.15)
	style_hover.shadow_size = 8
	btn.add_theme_stylebox_override("hover", style_hover)

	var style_pressed = style_normal.duplicate()
	style_pressed.bg_color = color.darkened(0.1)
	style_pressed.shadow_size = 2
	btn.add_theme_stylebox_override("pressed", style_pressed)

	btn.mouse_entered.connect(func(): _animar_boton_hover(btn))
	btn.mouse_exited.connect(func(): _animar_boton_salida(btn))

	return btn

func _crear_spacer(altura: float) -> Control:
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, altura)
	return spacer

func _animar_entrada(panel: Control):
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

func _obtener_nivel_actual(tipo_mejora: String) -> int:
	var valor_actual = SceneManager.player_data.mejoras.get(tipo_mejora, 1.0)

	# Calcular el nivel basado en el valor
	if tipo_mejora == "velocidad":
		# Velocidad aumenta en 0.2 por nivel (1.0, 1.2, 1.4, 1.6, 1.8, 2.0)
		return int((valor_actual - 1.0) / 0.2)
	elif tipo_mejora == "capacidad_bolsa":
		# Capacidad aumenta en 5 por nivel (10, 15, 20, 25, 30, 35)
		return int((valor_actual - 10) / 5)

	return 0

func _calcular_precio(tipo_mejora: String, nivel_actual: int) -> int:
	var config = mejoras_config[tipo_mejora]
	return int(config.precio_base * pow(config.incremento, nivel_actual))

func _actualizar_dinero():
	if money_label:
		var catnip = SceneManager.player_data.catnip
		money_label.text = "%d Catnip" % catnip

func _on_comprar_mejora(tipo_mejora: String):
	var config = mejoras_config[tipo_mejora]
	var nivel_actual = _obtener_nivel_actual(tipo_mejora)
	var precio = _calcular_precio(tipo_mejora, nivel_actual)
	var catnip = SceneManager.player_data.catnip

	# Verificar si tiene suficiente dinero
	if catnip < precio:
		_mostrar_mensaje_error("No tienes suficiente catnip")
		return

	# Verificar si ya está al máximo
	if nivel_actual >= config.max_nivel:
		_mostrar_mensaje_error("Ya tienes el nivel máximo")
		return

	# Realizar la compra
	SceneManager.player_data.catnip -= precio

	# Aplicar la mejora
	if tipo_mejora == "velocidad":
		SceneManager.player_data.mejoras["velocidad"] += 0.2
	elif tipo_mejora == "capacidad_bolsa":
		SceneManager.player_data.mejoras["capacidad_bolsa"] += 5

	# Efectos de sonido y visuales
	if has_node("/root/AudioManager") and AudioManager.has_method("play_sfx"):
		AudioManager.play_sfx("points")

	_mostrar_mensaje_exito("¡Compra exitosa!")

	# Actualizar UI
	_actualizar_dinero()
	_actualizar_item_ui(tipo_mejora)

func _actualizar_item_ui(tipo_mejora: String):
	# Buscar el item en la lista
	for item in shop_items:
		if item.tipo == tipo_mejora:
			var config = mejoras_config[tipo_mejora]
			var nivel_actual = _obtener_nivel_actual(tipo_mejora)
			var precio_nuevo = _calcular_precio(tipo_mejora, nivel_actual)

			# Actualizar label de nivel
			var nivel_label = item.nivel_label
			if nivel_actual >= config.max_nivel:
				nivel_label.text = "NIVEL MÁXIMO"
				nivel_label.add_theme_color_override("font_color", Color(1.0, 0.7, 0.3))
			else:
				nivel_label.text = "Nivel: %d/%d" % [nivel_actual, config.max_nivel]

			# Actualizar botón
			var boton_viejo = item.boton
			var parent = boton_viejo.get_parent()
			var btn_nuevo = _crear_boton_compra(tipo_mejora, precio_nuevo, nivel_actual >= config.max_nivel)
			btn_nuevo.name = "BtnComprar"

			var index = boton_viejo.get_index()
			parent.remove_child(boton_viejo)
			boton_viejo.queue_free()
			parent.add_child(btn_nuevo)
			parent.move_child(btn_nuevo, index)

			item.boton = btn_nuevo

			# Animación de compra exitosa
			var tween = create_tween()
			tween.tween_property(item.panel, "scale", Vector2(1.1, 1.1), 0.1)
			tween.tween_property(item.panel, "scale", Vector2(1.0, 1.0), 0.1)

			break

func _mostrar_mensaje_exito(texto: String):
	var mensaje = Label.new()
	mensaje.text = texto
	mensaje.add_theme_font_size_override("font_size", 32)
	mensaje.add_theme_color_override("font_color", Color(0.3, 0.8, 0.3))
	mensaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mensaje.set_anchors_preset(Control.PRESET_CENTER)
	mensaje.z_index = 1000

	# Sombra para legibilidad
	mensaje.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.5))
	mensaje.add_theme_constant_override("shadow_offset_x", 2)
	mensaje.add_theme_constant_override("shadow_offset_y", 2)

	main_container.add_child(mensaje)

	# Animación
	mensaje.modulate.a = 0
	mensaje.scale = Vector2(0.5, 0.5)

	var tween = create_tween()
	tween.tween_property(mensaje, "modulate:a", 1.0, 0.2)
	tween.tween_property(mensaje, "scale", Vector2(1.2, 1.2), 0.2)
	tween.tween_property(mensaje, "modulate:a", 0.0, 0.3).set_delay(1.0)

	await tween.finished
	mensaje.queue_free()

func _mostrar_mensaje_error(texto: String):
	var mensaje = Label.new()
	mensaje.text = texto
	mensaje.add_theme_font_size_override("font_size", 28)
	mensaje.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
	mensaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mensaje.set_anchors_preset(Control.PRESET_CENTER)
	mensaje.z_index = 1000

	# Sombra
	mensaje.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.5))
	mensaje.add_theme_constant_override("shadow_offset_x", 2)
	mensaje.add_theme_constant_override("shadow_offset_y", 2)

	main_container.add_child(mensaje)

	# Animación de shake
	mensaje.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(mensaje, "modulate:a", 1.0, 0.1)
	tween.tween_property(mensaje, "position:x", mensaje.position.x + 10, 0.05)
	tween.tween_property(mensaje, "position:x", mensaje.position.x - 10, 0.05)
	tween.tween_property(mensaje, "position:x", mensaje.position.x + 10, 0.05)
	tween.tween_property(mensaje, "position:x", mensaje.position.x, 0.05)
	tween.tween_property(mensaje, "modulate:a", 0.0, 0.3).set_delay(1.0)

	await tween.finished
	mensaje.queue_free()

func _on_salir_pressed():
	# Animación de salida
	var tween = create_tween()
	tween.tween_property(main_container, "modulate:a", 0.0, 0.3)
	await tween.finished

	# Volver al menú principal
	get_tree().change_scene_to_file("res://scenes/mainmenu/MainMenu.tscn")
