extends Node2D

# Script para la escena interior de la tienda

func _ready():
	# Asegurarse de que el juego NO esté pausado
	get_tree().paused = false

	# Verificar que el jugador pueda moverse
	var player = get_tree().get_first_node_in_group("player")
	if player:
		print("Jugador encontrado en tienda interior")
		# Asegurar que el jugador pueda procesar
		player.set_process(true)
		player.set_physics_process(true)
		player.set_process_input(true)
	else:
		push_warning("No se encontró el jugador en tienda_interior")
