extends Area2D

# Estados de la planta
enum PlantState { EMPTY, SEED, SPROUT, MATURE }

# Variables exportadas
@export var growth_time = 5 # Tiempo total de crecimiento en segundos

# Referencias
@onready var sprite = $Sprite2D
@onready var particles = $GPUParticles2D if has_node("GPUParticles2D") else null

# Estado actual
var current_state = PlantState.EMPTY
var growth_timer = 0.0

# Texturas para cada estado
var textures = {
	PlantState.EMPTY: null,
	PlantState.SEED: preload("res://assets/plants/seed.png"),
	PlantState.SPROUT: preload("res://assets/plants/sprout.png"),
	PlantState.MATURE: preload("res://assets/plants/mature.png")
}

func _ready():
	add_to_group("plants")
	# Configurar colisión
	input_pickable = true
	
	# Iniciar vacío
	update_visual()

func _process(delta):
	# Crecimiento automático - SOLUCIÓN CORREGIDA
	if current_state == PlantState.SEED or current_state == PlantState.SPROUT:
		growth_timer += delta
		
		# Mostrar progreso cada 0.5 segundos (para no saturar consola)
		if int(growth_timer * 2) != int((growth_timer - delta) * 2):
			print("Planta creciendo: ", growth_timer, "/", growth_time, " - Progreso: ", (growth_timer/growth_time)*100, "%")
		
		# Pasar a brote (50% del tiempo) - solo si está en SEED
		if current_state == PlantState.SEED and growth_timer >= growth_time * 0.5:
			change_state(PlantState.SPROUT)
			print("¡Planta creció a SPROUT!")
		
		# Pasar a madura (100% del tiempo)
		if growth_timer >= growth_time:
			change_state(PlantState.MATURE)
			growth_timer = 0.0
			print("¡Planta creció a MATURE!")

func interact():
	match current_state:
		PlantState.EMPTY:
			plant_seed()
		PlantState.MATURE:
			harvest()

func plant_seed():
	if current_state == PlantState.EMPTY:
		change_state(PlantState.SEED)
		growth_timer = 0.0
		play_particle_effect()
		print("Semilla plantada!")

func harvest():
	if current_state == PlantState.MATURE:
		# Notificar al GameManager
		if get_tree().root.has_node("Main/GameManager"):
			var game_manager = get_tree().root.get_node("Main/GameManager")
			game_manager.add_score(10)
		
		# Volver a estado vacío
		change_state(PlantState.EMPTY)
		play_particle_effect()
		print("Planta cosechada!")

func change_state(new_state: PlantState):
	current_state = new_state
	update_visual()
	
	# DEBUG: Mostrar cambio de estado
	var state_names = {
		PlantState.EMPTY: "EMPTY", 
		PlantState.SEED: "SEED", 
		PlantState.SPROUT: "SPROUT", 
		PlantState.MATURE: "MATURE"
	}
	print("Planta cambió a estado: ", state_names[new_state])

func update_visual():
	if textures[current_state] != null:
		sprite.texture = textures[current_state]
		sprite.visible = true
	else:
		sprite.visible = false

func play_particle_effect():
	if particles:
		particles.emitting = true

func is_mature():
	return current_state == PlantState.MATURE

func get_eaten():
	print("¡La planta está siendo comida!")
	
	# Deshabilitar colisión inmediatamente
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	# Opcional: animación o efectos antes de eliminar
	if particles:
		particles.emitting = true
	
	# Eliminar la planta después de un breve momento
	await get_tree().create_timer(0.1).timeout
	queue_free()
