extends Node

# Autoload para gestionar cambios de escena

signal scene_changed(scene_name: String)

var current_scene: String = ""
var player_data: Dictionary = {
	"catnip": 0,
	"plantas_plantadas": 0,
	"shop_unlocked": false,
	"last_position": Vector2.ZERO,
	"last_scene": "",
	"mejoras": {
		"velocidad": 1.0,
		"capacidad_bolsa": 10
	}
}

func _ready():
	current_scene = get_tree().current_scene.name

func change_scene(scene_path: String):
	# Fade out/in opcional aquí
	call_deferred("_deferred_change_scene", scene_path)

func _deferred_change_scene(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
	scene_changed.emit(scene_path)

func reset_player_data():
	player_data = {
		"catnip": 0,
		"plantas_plantadas": 0,
		"shop_unlocked": false,
		"last_position": Vector2.ZERO,
		"last_scene": "",
		"mejoras": {
			"velocidad": 1.0,
			"capacidad_bolsa": 10
		}
	}

func unlock_shop():
	player_data.shop_unlocked = true
	print("¡La tienda ha sido desbloqueada!")
