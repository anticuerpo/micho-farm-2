# simple_main_menu.gd
extends Control

func _ready():
	# Configurar que este Control ocupe toda la pantalla
	size = get_viewport_rect().size
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	# Crear elementos de UI programáticamente
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.anchor_left = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_bottom = 0.5
	vbox.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(vbox)
	
	# Espacio antes del título
	var spacer1 = Control.new()
	spacer1.custom_minimum_size = Vector2(0, 80)
	vbox.add_child(spacer1)
	
	# Título
	var title = Label.new()
	title.text = "MICHO'S FARM"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 64)  # Más grande
	title.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(title)
	
	# Espacio entre título y botones
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 100)  # Más espacio
	vbox.add_child(spacer2)
	
	# Botón Start
	var start_btn = Button.new()
	start_btn.text = "INICIAR JUEGO"
	start_btn.custom_minimum_size = Vector2(400, 80)  # Más grande
	start_btn.add_theme_font_size_override("font_size", 28)
	start_btn.add_theme_color_override("font_color", Color.WHITE)
	start_btn.add_theme_stylebox_override("normal", _create_stylebox(Color(0.2, 0.6, 0.2)))
	start_btn.add_theme_stylebox_override("hover", _create_stylebox(Color(0.3, 0.7, 0.3)))
	start_btn.add_theme_stylebox_override("pressed", _create_stylebox(Color(0.1, 0.5, 0.1)))
	start_btn.pressed.connect(_on_start_pressed)
	vbox.add_child(start_btn)
	
	# Espacio entre botones
	var spacer3 = Control.new()
	spacer3.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(spacer3)
	
	# Botón Exit
	var exit_btn = Button.new()
	exit_btn.text = "SALIR" 
	exit_btn.custom_minimum_size = Vector2(400, 80)  # Más grande
	exit_btn.add_theme_font_size_override("font_size", 28)
	exit_btn.add_theme_color_override("font_color", Color.WHITE)
	exit_btn.add_theme_stylebox_override("normal", _create_stylebox(Color(0.7, 0.2, 0.2)))
	exit_btn.add_theme_stylebox_override("hover", _create_stylebox(Color(0.8, 0.3, 0.3)))
	exit_btn.add_theme_stylebox_override("pressed", _create_stylebox(Color(0.6, 0.1, 0.1)))
	exit_btn.pressed.connect(_on_exit_pressed)
	vbox.add_child(exit_btn)
	
	# Espacio después de los botones
	var spacer4 = Control.new()
	spacer4.custom_minimum_size = Vector2(0, 80)
	vbox.add_child(spacer4)

func _create_stylebox(color: Color) -> StyleBoxFlat:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = color
	stylebox.corner_radius_top_left = 15
	stylebox.corner_radius_top_right = 15
	stylebox.corner_radius_bottom_right = 15
	stylebox.corner_radius_bottom_left = 15
	stylebox.border_width_left = 3
	stylebox.border_width_top = 3
	stylebox.border_width_right = 3
	stylebox.border_width_bottom = 3
	stylebox.border_color = Color(1, 1, 1, 0.8)
	stylebox.shadow_size = 8
	stylebox.shadow_color = Color(0, 0, 0, 0.5)
	return stylebox

func _on_start_pressed():
	print("Iniciando juego...")
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")

func _on_exit_pressed():
	print("Saliendo del juego...")
	get_tree().quit()

# Asegurar que se redimensione cuando cambie el tamaño de la ventana
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		size = get_viewport_rect().size
