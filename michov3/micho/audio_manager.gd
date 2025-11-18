# audio_manager.gd
# Este script es un Autoload (Singleton) para manejar toda la música y sonidos del juego

extends Node

# Referencias a los reproductores de audio
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

# Volúmenes (0.0 a 1.0)
var music_volume: float = 0.5
var sfx_volume: float = 0.7

# Tracks de música disponibles
var music_tracks = {

	"juego": "res://audio/musica/1_new_life_master.mp3",
}

# Efectos de sonido disponibles
var sound_effects = {
	"click": "res://audio/sfx/click.ogg",
	"planta": "res://audio/sfx/plant.ogg",
	"cosecha": "res://audio/sfx/harvest.ogg",
	"ahuyentar": "res://audio/sfx/scare.ogg",
	"puntos": "res://audio/sfx/points.ogg"
}

func _ready():
	# Crear reproductores de audio
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Music"  # Opcional: crear bus en AudioBusLayout
	add_child(music_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.bus = "SFX"  # Opcional: crear bus en AudioBusLayout
	add_child(sfx_player)
	
	# Configurar volúmenes
	set_music_volume(music_volume)
	set_sfx_volume(sfx_volume)

# ===== MÚSICA =====

func play_music(track_name: String, fade_in: bool = true):
	"""Reproduce una pista de música. Si fade_in=true, hace fade in suave."""
	
	# Verificar si existe la pista
	if not music_tracks.has(track_name):
		push_error("Pista de música no encontrada: " + track_name)
		return
	
	var track_path = music_tracks[track_name]
	
	# Cargar el audio
	var stream = load(track_path)
	if not stream:
		push_error("No se pudo cargar: " + track_path)
		return
	
	# Si ya está reproduciendo la misma canción, no hacer nada
	if music_player.stream == stream and music_player.playing:
		return
	
	# Fade out de la música actual si está sonando
	if music_player.playing and fade_in:
		await fade_out_music(0.5)
	
	# Configurar nueva música
	music_player.stream = stream
	music_player.play()
	
	# Fade in si está habilitado
	if fade_in:
		fade_in_music(1.0)

func stop_music(fade_out_duration: float = 0.5):
	"""Detiene la música con fade out opcional."""
	if fade_out_duration > 0:
		await fade_out_music(fade_out_duration)
	music_player.stop()

func fade_in_music(duration: float = 1.0):
	"""Fade in gradual de la música."""
	music_player.volume_db = -80  # Muy bajo
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", linear_to_db(music_volume), duration)

func fade_out_music(duration: float = 0.5):
	"""Fade out gradual de la música."""
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80, duration)
	await tween.finished

func set_music_volume(volume: float):
	"""Ajusta el volumen de la música (0.0 a 1.0)."""
	music_volume = clamp(volume, 0.0, 1.0)
	music_player.volume_db = linear_to_db(music_volume)

# ===== EFECTOS DE SONIDO =====

func play_sound(sound_name: String):
	"""Reproduce un efecto de sonido."""
	
	# Verificar si existe el sonido
	if not sound_effects.has(sound_name):
		push_warning("Efecto de sonido no encontrado: " + sound_name)
		return
	
	var sound_path = sound_effects[sound_name]
	var stream = load(sound_path)
	
	if not stream:
		push_warning("No se pudo cargar: " + sound_path)
		return
	
	# Crear un reproductor temporal para este sonido
	var temp_player = AudioStreamPlayer.new()
	temp_player.stream = stream
	temp_player.volume_db = linear_to_db(sfx_volume)
	temp_player.bus = "SFX"
	add_child(temp_player)
	
	temp_player.play()
	
	# Eliminar el reproductor cuando termine
	temp_player.finished.connect(func():
		temp_player.queue_free()
	)

func set_sfx_volume(volume: float):
	"""Ajusta el volumen de efectos de sonido (0.0 a 1.0)."""
	sfx_volume = clamp(volume, 0.0, 1.0)
	sfx_player.volume_db = linear_to_db(sfx_volume)

# ===== UTILIDADES =====

func linear_to_db(linear: float) -> float:
	"""Convierte volumen lineal (0-1) a decibeles."""
	if linear <= 0:
		return -80
	return 20 * log(linear) / log(10)
