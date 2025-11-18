extends CanvasLayer

# UI de tienda como overlay - se puede cerrar

var main_container: Control
var money_label: Label
var shop_items: Array = []

# Precios de mejoras (copiado de tienda.gd)
var mejoras_config = {
	"velocidad": {
		"nombre": "Botas Rápidas",
		"descripcion": "Aumenta tu velocidad",
		"precio_base": 50,
		"incremento": 1.5,
		"max_nivel": 5,
		"emoji": "⚡",
		"color": Color(0.9, 0.85, 0.6)
	},
	"capacidad_bolsa": {
		"nombre": "Bolsa Grande",
		"descripcion": "Aumenta tu capacidad",
		"precio_base": 75,
		"incremento": 1.4,
		"max_nivel": 5,
		"emoji": "🎒",
		"color": Color(0.85, 0.9, 0.95)
	}
}

func _ready():
	layer = 100
	_crear_ui_tienda()
	_actualizar_dinero()

	# Pausar el juego mientras está abierta la tienda
	get_tree().paused = true

func _crear_ui_tienda():
	# Contenedor principal
	main_container = Control.new()
	main_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(main_container)

	# Fondo semi-transparente
	var overlay = ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.7)
	main_container.add_child(overlay)

	# Fondo de color
	var fondo = ColorRect.new()
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo.color = Color(0.9, 0.85, 0.95)
	fondo.modulate.a = 0.3
	main_container.add_child(fondo)

	# Panel principal
	var shop_panel = Panel.new()
	shop_panel.custom_minimum_size = Vector2(700, 550)
	shop_panel.set_anchors_preset(Control.PRESET_CENTER)
	shop_panel.position = Vector2(-350, -275)
	shop_panel.add_theme_stylebox_override("panel", _crear_panel_kawaii())
	main_container.add_child(shop_panel)

	# VBox principal
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 20)
	shop_panel.add_child(vbox)

	vbox.add_child(_crear_spacer(20))

	# Header
	_crear_header(vbox)

	# Panel de dinero
	_crear_panel_dinero(vbox)

	vbox.add_child(_crear_spacer(10))

	# Mensaje
	var mensaje = Label.new()
	mensaje.text = "Bienvenido a la tienda"
	mensaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje.add_theme_font_size_override("font_size", 18)
	mensaje.add_theme_color_override("font_color", Color(0.5, 0.4, 0.6))
	vbox.add_child(mensaje)

	vbox.add_child(_crear_spacer(15))

	# Items
	var items_container = VBoxContainer.new()
	items_container.add_theme_constant_override("separation", 15)
	items_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(items_container)

	_crear_item_mejora(items_container, "velocidad")
	_crear_item_mejora(items_container, "capacidad_bolsa")

	vbox.add_child(_crear_spacer(20))

	# Botón cerrar
	var btn_cerrar = _crear_boton_kawaii("CERRAR", Color(0.95, 0.8, 0.85))
	btn_cerrar.pressed.connect(_on_cerrar_pressed)
	btn_cerrar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(btn_cerrar)

	vbox.add_child(_crear_spacer(20))

	# Animación de entrada
	_animar_entrada(shop_panel)

# [Copiar todas las funciones de tienda.gd aquí...]
# Por brevedad, voy a incluir solo las esenciales

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
	style.bg_color = Color(0.95, 0.95, 0.7, 0.9)
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

	var hbox = HBoxContainer.new()
	hbox.position = Vector2(20, 20)
	hbox.add_theme_constant_override("separation", 20)

	var emoji_label = Label.new()
	emoji_label.text = config.emoji
	emoji_label.add_theme_font_size_override("font_size", 48)
	hbox.add_child(emoji_label)

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

	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(spacer)

	var btn_comprar = _crear_boton_compra(tipo_mejora, precio_actual, nivel_actual >= config.max_nivel)
	btn_comprar.name = "BtnComprar"
	hbox.add_child(btn_comprar)

	item_panel.add_child(hbox)
	parent.add_child(item_panel)

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

		var style_normal = StyleBoxFlat.new()
		style_normal.bg_color = Color(0.7, 0.9, 0.7)
		style_normal.set_corner_radius_all(15)
		style_normal.border_width_left = 3
		style_normal.border_width_top = 3
		style_normal.border_width_right = 3
		style_normal.border_width_bottom = 3
		style_normal.border_color = Color(1, 1, 1, 0.8)
		btn.add_theme_stylebox_override("normal", style_normal)

		var style_hover = style_normal.duplicate()
		style_hover.bg_color = Color(0.7, 0.9, 0.7).lightened(0.15)
		btn.add_theme_stylebox_override("hover", style_hover)

		var style_pressed = style_normal.duplicate()
		style_pressed.bg_color = Color(0.7, 0.9, 0.7).darkened(0.1)
		btn.add_theme_stylebox_override("pressed", style_pressed)

		btn.pressed.connect(_on_comprar_mejora.bind(tipo_mejora))

	return btn

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
	btn.add_theme_stylebox_override("normal", style_normal)

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

func _obtener_nivel_actual(tipo_mejora: String) -> int:
	var valor_actual = SceneManager.player_data.mejoras.get(tipo_mejora, 1.0)

	if tipo_mejora == "velocidad":
		return int((valor_actual - 1.0) / 0.2)
	elif tipo_mejora == "capacidad_bolsa":
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

	if catnip < precio:
		print("No tienes suficiente catnip")
		return

	if nivel_actual >= config.max_nivel:
		print("Ya tienes el nivel máximo")
		return

	# Realizar compra
	SceneManager.player_data.catnip -= precio

	if tipo_mejora == "velocidad":
		SceneManager.player_data.mejoras["velocidad"] += 0.2
	elif tipo_mejora == "capacidad_bolsa":
		SceneManager.player_data.mejoras["capacidad_bolsa"] += 5

	_actualizar_dinero()
	print("¡Compra exitosa!")

func _on_cerrar_pressed():
	# Despausar el juego
	get_tree().paused = false

	# Animación de salida
	var tween = create_tween()
	tween.tween_property(main_container, "modulate:a", 0.0, 0.3)
	await tween.finished

	# Cerrar la UI
	queue_free()

func _input(event):
	# Permitir cerrar con ESC
	if event.is_action_pressed("ui_cancel"):
		_on_cerrar_pressed()
