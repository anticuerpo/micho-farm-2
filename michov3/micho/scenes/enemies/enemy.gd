class_name Enemy
extends CharacterBody2D

enum State {
	WANDER,
	SEEK_PLANT,
	EATING
}

@export var speed: float = 50.0
@export var eating_time: float = 3.0

var current_state: State = State.WANDER
var current_plant: Node2D = null
var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
var eating_timer: float = 0.0
var stuck_timer: float = 0.0
var last_position: Vector2 = Vector2.ZERO

@onready var detection_area: Area2D = $DetectionArea

func _ready():
	randomize()
	_change_state(State.WANDER)
	detection_area.area_entered.connect(_on_detection_area_entered)

func _physics_process(delta):
	match current_state:
		State.WANDER:
			_wander_state(delta)
		State.SEEK_PLANT:
			_seek_plant_state(delta)
		State.EATING:
			_eating_state(delta)
	
	move_and_slide()

func _change_state(new_state: State):
	current_state = new_state
	
	match new_state:
		State.WANDER:
			_set_random_wander_direction()
			wander_timer = randf_range(2.0, 5.0)
			print("Cambiando a estado: WANDER")
		
		State.SEEK_PLANT:
			print("Cambiando a estado: SEEK_PLANT")
			stuck_timer = 0.0
			last_position = global_position
		
		State.EATING:
			print("Cambiando a estado: EATING")
			eating_timer = eating_time
			velocity = Vector2.ZERO

func _wander_state(delta):
	# Movimiento aleatorio
	velocity = wander_direction * speed
	
	# Cambiar dirección periódicamente
	wander_timer -= delta
	if wander_timer <= 0:
		_set_random_wander_direction()
		wander_timer = randf_range(2.0, 5.0)

func _seek_plant_state(delta):
	if current_plant == null or not is_instance_valid(current_plant):
		_change_state(State.WANDER)
		return
	
	# Detección de atascamiento
	if global_position.distance_to(last_position) < 2.0:
		stuck_timer += delta
		if stuck_timer > 3.0:  # Si está atascado por 3 segundos
			print("¡Enemigo atascado! Buscando nueva planta...")
			_change_state(State.WANDER)
			current_plant = null
			return
	else:
		stuck_timer = 0.0
		last_position = global_position
	
	# Calcular distancia a la planta
	var distance_to_plant = global_position.distance_to(current_plant.global_position)
	
	# DEBUG: Mostrar distancia
	print("Siguiendo planta - Distancia: ", distance_to_plant)
	
	# Si estamos lo suficientemente cerca, comenzar a comer
	# Aumenté el umbral para evitar que se atasquen
	if distance_to_plant <= 35.0:
		print("¡Enemigo llegó a la planta! Comenzando a comer...")
		_change_state(State.EATING)
		return
	
	# Movimiento hacia la planta
	var direction = (current_plant.global_position - global_position).normalized()
	velocity = direction * speed

func _eating_state(delta):
	if current_plant == null or not is_instance_valid(current_plant):
		_change_state(State.WANDER)
		return
	
	# Verificar que todavía estamos cerca de la planta
	var distance_to_plant = global_position.distance_to(current_plant.global_position)
	if distance_to_plant > 45.0:  # Si nos alejamos, volver a seguir
		print("Nos alejamos de la planta, volviendo a seguir...")
		_change_state(State.SEEK_PLANT)
		return
	
	# Lógica para comer la planta
	eating_timer -= delta
	if eating_timer <= 0:
		print("¡El gato se comió una planta!")
		if current_plant.has_method("get_eaten"):
			current_plant.get_eaten()
		_change_state(State.WANDER)
		current_plant = null

func _set_random_wander_direction():
	# Generar una dirección aleatoria
	var angle = randf() * 2 * PI
	wander_direction = Vector2(cos(angle), sin(angle))

func _on_detection_area_entered(area: Area2D):
	if current_state == State.EATING:
		return
	
	if area.is_in_group("plants"):
		print("=== PLANTA DETECTADA ===")
		print("Tipo: ", area.name)
		print("Grupos: ", area.get_groups())
		
		# Verificar si la planta está madura
		if area.has_method("is_mature") and area.is_mature():
			print("¡PLANTA MADURA DETECTADA! Cambiando a estado SEEK_PLANT")
			current_plant = area
			_change_state(State.SEEK_PLANT)
		else:
			print("Planta detectada pero no está madura")
		
		print("======================")

# Función para forzar cambio de estado si es necesario
func _unstick_enemy():
	if current_state == State.SEEK_PLANT and stuck_timer > 2.0:
		print("Forzando desatascamiento del enemigo...")
		_change_state(State.WANDER)
		current_plant = null
# Agrega esta función al script del enemigo (enemy.gd)

func scare_away(player_position: Vector2):
	print("¡Enemigo asustado! Huyendo...")
	
	# Cambiar a estado WANDER inmediatamente
	_change_state(State.WANDER)
	current_plant = null
	
	# Opcional: agregar un efecto visual o de sonido
	# Opcional: hacer que huya en dirección opuesta al jugador
	var flee_direction = (global_position - player_position).normalized()
	wander_direction = flee_direction
	wander_timer = 2.0  # Huir por 2 segundos
	
	# Opcional: hacer que el enemigo no pueda detectar plantas por un tiempo
	# detection_area.monitoring = false
	# await get_tree().create_timer(3.0).timeout
	# detection_area.monitoring = true
