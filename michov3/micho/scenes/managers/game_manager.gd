extends Node

var score = 0
var plants_harvested = 0
var win_condition = 5

# IMPORTANTE: Ajustar esta ruta según tu estructura
var score_label  # No usar @onready todavía

func _ready():
	# Buscar el ScoreLabel dinámicamente
	score_label = get_node("../UI/ScoreLabel")
	if score_label:
		update_score_display()
	else:
		push_error("No se encontró ScoreLabel en ../UI/ScoreLabel")

func add_score(points: int):
	score += points
	plants_harvested += 1
	
	update_score_display()
	
	if plants_harvested >= win_condition:
		win_game()

func update_score_display():
	if score_label:
		score_label.text = "Puntos: %d | Plantas: %d/%d" % [score, plants_harvested, win_condition]

func win_game():
	print("¡VICTORIA! Has cosechado suficientes plantas")
	# Por ahora solo imprimir, después añadiremos pantalla de victoria
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()  # Reiniciar por ahora
