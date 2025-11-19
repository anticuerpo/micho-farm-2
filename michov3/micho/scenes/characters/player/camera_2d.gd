extends Camera2D

var player = null

func _ready():
	# Buscar al jugador como padre
	player = get_parent()
	if not player or not player.is_in_group("player"):
		# Si no es el padre, buscar en el grupo "player"
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]

func _process(delta):
	if player:
		global_position = player.global_position
