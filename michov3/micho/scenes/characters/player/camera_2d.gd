extends Camera2D

@onready var player = get_node("/root/Main/Player")  
func _process(delta):
	if player: 
		global_position = player.global_position  
