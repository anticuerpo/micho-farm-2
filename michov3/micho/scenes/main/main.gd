extends Node2D

func _ready():
	# Inicia el diálogo automáticamente al cargar
	Dialogic.start("intro_historia")
	
	# Conecta la señal para saber cuándo termina
	Dialogic.timeline_ended.connect(_on_intro_terminada)
	AudioManager.play_music("juego")
func _on_intro_terminada():
	print("Introducción terminada, el juego puede comenzar")
	# Aquí puedes activar el control del jugador, etc.
