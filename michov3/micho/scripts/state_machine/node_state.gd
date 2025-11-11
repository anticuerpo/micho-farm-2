class_name NodeState
extends Node

@warning_ignore("unused_signal")
signal transition 


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass

func find_animated_sprite() -> AnimatedSprite2D:
	if has_node("AnimatedSprite2D"):
		return get_node("AnimatedSprite2D")
	
	# Buscar recursivamente
	var parent = get_parent()
	while parent:
		for child in parent.get_children():
			if child is AnimatedSprite2D:
				return child
		parent = parent.get_parent()
	
	return null
