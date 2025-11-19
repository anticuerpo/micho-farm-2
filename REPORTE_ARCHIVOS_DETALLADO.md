# REPORTE DE ARCHIVOS - MICHO FARM 2
## Verificación de implementación por archivo

---

## PROGRAMACIÓN - ARCHIVOS CLAVE

### Audio Manager (Sistema de Música y Efectos)
```
ARCHIVO: /home/user/micho-farm-2/michov3/micho/audio_manager.gd
LINEAS: 145
ESTADO: ✅ COMPLETO

CONTENIDO VERIFICADO:
- Línea 1-2: Comentarios de propósito
- Línea 4: extends Node (Autoload/Singleton)
- Línea 7-8: Referencias a AudioStreamPlayer
- Línea 15-18: Diccionario de tracks de música
  * "juego": "res://audio/musica/1_new_life_master.mp3" ✅
- Línea 21-27: Diccionario de efectos de sonido (no implementados)
  * "click": "res://audio/sfx/click.ogg" ❌ FALTA ARCHIVO
  * "planta": "res://audio/sfx/plant.ogg" ❌ FALTA ARCHIVO
  * "cosecha": "res://audio/sfx/harvest.ogg" ❌ FALTA ARCHIVO
  * "ahuyentar": "res://audio/sfx/scare.ogg" ❌ FALTA ARCHIVO
  * "puntos": "res://audio/sfx/points.ogg" ❌ FALTA ARCHIVO
- Línea 47-77: Funciones de música con fade in/out
- Línea 104-131: Funciones de efectos de sonido
```

### Player (Movimiento y Mecánicas)
```
ARCHIVO: /home/user/micho-farm-2/michov3/micho/scenes/characters/player/player.gd
LINEAS: 273
ESTADO: ✅ IMPLEMENTADO

FUNCIONES CLAVE:
- _ready(): Configuración inicial
- _input(event): Manejo de entrada (plantación, ahuyentar)
- _process(delta): Actualización de cooldowns y partículas
- attempt_plant_interaction(): Raycast y plantación
- attempt_scare_enemies(): Ahuyentar enemigos (ESPACIO)
- show_scare_effect(): Efecto visual de grito con shader
- plant_new_plant(): Crear nueva planta
- get_facing_direction_name(): Obtener dirección del jugador
- set_tool(), get_current_tool(): Manejo de herramientas
- mostrar_burbuja_bonita(): Diálogos flotantes

CARACTERÍSTICAS:
- Particulas dinámicas de pisadas (linea 3, 38-42)
- Sistema de cooldown de interacciones (linea 11-12)
- Radio de ahuyentar: 150.0 (linea 13)
- Efecto visual con shader personalizado (linea 92-105)
```

### Game Manager (Puntuación y Mecánicas)
```
ARCHIVO: /home/user/micho-farm-2/michov3/micho/scenes/managers/game_manager.gd
LINEAS: 200+ (parcialmente mostrado)
ESTADO: ✅ IMPLEMENTADO

CONTENIDO:
- Señales: score_changed, plants_changed, dirt_count_changed, level_completed, game_over
- Variables exportadas:
  * max_plants = 10
  * max_dirt_stains = 10 (para nivel 2)
  * current_level = 1
  * win_condition = 10
- UI Panel con:
  * Puntuación (⭐ icon)
  * Contador de plantas (🌸 icon)
  * Contador de manchas (📍 icon, solo nivel 2)
- Estilos Kawaii:
  * BorderRadius: 20px
  * Sombras con offset (0, 4)
  * Colores pastel
```

### Enemigos (Comportamiento IA)
```
ARCHIVO: /home/user/micho-farm-2/michov3/micho/scenes/enemies/enemy.gd
LINEAS: 100+
ESTADO: ✅ IMPLEMENTADO

ESTADOS:
- WANDER: Movimiento aleatorio
- SEEK_PLANT: Seguimiento de plantas
- EATING: Comiendo plantas

CARACTERÍSTICAS:
- Velocidad: 50.0 por defecto
- Tiempo de comida: 3.0 segundos
- Detección de atascamiento (3 segundos)
- Rango de detección de plantas (35.0 unidades)
- Método scare_away() para huir
```

### Plantas (Ciclo de vida)
```
ARCHIVO: /home/user/micho-farm-2/michov3/micho/scenes/plants/plant.gd
LINEAS: 120
ESTADO: ✅ IMPLEMENTADO

ESTADOS:
- EMPTY: Sin semilla
- SEED: Semilla plantada
- SPROUT: Brote (50% del tiempo de crecimiento)
- MATURE: Planta lista para cosechar

CARACTERÍSTICAS:
- Tiempo de crecimiento: 10 segundos
- Texuras para cada estado:
  * Seed: res://assets/plants/seed.png ✅
  * Sprout: res://assets/plants/sprout.png ✅
  * Mature: res://assets/plants/mature.png ✅
- Partículas en cosecha/plantación
- Notificación a GameManager al cosechar

SISTEMA DE PUNTOS:
- Cosecha = +10 puntos (catnip)
```

---

## DISEÑO VISUAL - ARCHIVOS DE ASSETS

### Sprites de Plantas
```
✅ /home/user/micho-farm-2/michov3/micho/assets/plants/seed.png
✅ /home/user/micho-farm-2/michov3/micho/assets/plants/sprout.png
✅ /home/user/micho-farm-2/michov3/micho/assets/plants/mature.png
```

### Tilesets
```
✅ /home/user/micho-farm-2/michov3/micho/assets/game/tilesets/Grass.png
✅ /home/user/micho-farm-2/michov3/micho/assets/game/tilesets/Water.png
✅ /home/user/micho-farm-2/michov3/micho/assets/game/tilesets/Tilled_Dirt_v2.png
✅ /home/user/micho-farm-2/michov3/micho/assets/game/tilesets/Tilled_Dirt_Wide_v2.png
✅ /home/user/micho-farm-2/michov3/micho/assets/game/tilesets/Hills.png
✅ /home/user/micho-farm-2/michov3/micho/assets/game/tilesets/neko-office-tileset.png
✅ /home/user/micho-farm-2/michov3/micho/assets/game/tilesets/Doors.png
✅ /home/user/micho-farm-2/michov3/micho/assets/game/tilesets/Fences.png
```

### Otros Assets
```
✅ /home/user/micho-farm-2/michov3/micho/assets/game/objects/Free_Chicken_House.png
✅ /home/user/micho-farm-2/michov3/micho/assets/Sprout Lands - UI Pack - Basic pack/emojis-free/star2.png
```

### Tileset Resources
```
✅ /home/user/micho-farm-2/michov3/micho/Tilesets/game_tile_set.tres
✅ /home/user/micho-farm-2/michov3/micho/Tilesets/house_tile_set.tres
```

---

## EFECTOS DE PARTÍCULAS

### Sistema de Partículas de Miedo
```
ARCHIVO ESCENA: /home/user/micho-farm-2/michov3/micho/scenes/characters/player/scare_particles.tscn
ARCHIVO SCRIPT: /home/user/micho-farm-2/michov3/micho/scenes/characters/player/scare_particles.gd
ARCHIVO SHADER: /home/user/micho-farm-2/michov3/micho/scenes/characters/player/scare_particles.gdshader
ESTADO: ✅ COMPLETO

CONFIGURACIÓN:
- Nodo: GPUParticles2D
- Cantidad: 25 partículas
- Lifetime: 0.69 segundos
- Explosividad: 0.8
- One-shot: true (se genera una explosión)
- Emission shape: Point
- Material: ShaderMaterial personalizado

SHADER:
- Tipo: shader_type particles;
- Métodos: start() y process() (vacíos en base)
```

### Partículas en Plantas
```
UBICACIÓN: /home/user/micho-farm-2/michov3/micho/scenes/plants/plant.tscn
TIPO: GPUParticles2D
ACTIVACIÓN: Al cosechar o plantar

FUNCIÓN:
- Retroalimentación visual de plantación/cosecha
- Llamada desde plant.gd línea 100-101
```

### Partículas de Pisadas
```
UBICACIÓN: /home/user/micho-farm-2/michov3/micho/scenes/main/Main.tscn
NODO: ParticulasPisadas
TIPO: GPUParticles2D
MATERIAL: ParticleProcessMaterial_sjxhf

CONFIGURACIÓN:
- Ángulo: -217.2° a -171.5°
- Gravedad: 98 (efecto de caída)
- Escala: 0.7
- Emission shape: 4 (Point count)
```

---

## INTERFAZ - MENÚS Y HUD

### Menú Principal
```
ARCHIVO: /home/user/micho-farm-2/michov3/micho/scenes/mainmenu/main_menu.gd
ESCENA: /home/user/micho-farm-2/michov3/micho/scenes/mainmenu/MainMenu.tscn
ESTADO: ✅ COMPLETO

ELEMENTOS:
- Fondo ColorRect (Color 0.85, 0.95, 0.85) - Verde pastel
- Panel central (500x560) con border radius 25px
- Título: "🌸 MICHO'S FARM 🌸" (48px, color 0.4, 0.7, 0.4)
- Subtítulo: "✿ Una aventura de jardinería ✿" (16px)

BOTONES:
- 🌱 INICIAR JUEGO 🌱 → _on_start_pressed()
- ⚙️ OPCIONES → _on_opciones_pressed()
- 🌙 SALIR → _on_exit_pressed()

DECORACIONES:
- Nubes flotantes (4 nubes con animación)
- Flores en esquinas (🌸🌼🌺 arriba, 🌻🌷🌹 abajo)

ANIMACIÓN:
- Entrada: modulate.a + scale (0.8 → 1.0 en 0.5s)
- Hover: scale 1.0 → 1.05
- Botones con shadow_size = 5, shadow_offset = (0, 3)
```

### HUD - Interfaz de Juego
```
ARCHIVO GENERADOR: /home/user/micho-farm-2/michov3/micho/scenes/managers/game_manager.gd
UBICACIÓN: CanvasLayer (20, 20)
ESTADO: ✅ GENERADO DINÁMICAMENTE

PANEL PRINCIPAL:
- Tamaño: 280x100 (280x140 en nivel 2)
- Posición: (20, 20)
- Border radius: 20px
- Sombra: size=10, offset=(0, 4)

FILA 1 - PUNTUACIÓN:
- Icono: ⭐ (24px)
- Texto: "Puntos: 0" (20px, color 0.4, 0.6, 0.8)

FILA 2 - PLANTAS:
- Icono: 🌸 (24px)
- Texto: "Plantas: 0/10" (20px, color 0.5, 0.8, 0.5)

FILA 3 - MANCHAS (solo nivel 2):
- Icono: 📍 (24px)
- Texto: "Manchas: 0/10" (20px, color 0.8, 0.5, 0.5)

ACTUALIZACIÓN:
- Señales: score_changed, plants_changed, dirt_count_changed
```

### Tienda UI
```
ARCHIVO: /home/user/micho-farm-2/michov3/micho/scenes/tienda/tienda_ui.gd
ESCENA: /home/user/micho-farm-2/michov3/micho/scenes/tienda/tienda_ui.tscn
ESTADO: ✅ GENERADO DINÁMICAMENTE
TIPO: CanvasLayer (z_index = 100)

COMPONENTES PRINCIPALES:
1. OVERLAY OSCURO
   - Fondo ColorRect (alpha 0.7)

2. PANEL PRINCIPAL
   - Tamaño: 700x550
   - Border radius: 25px
   - Sombra: size=20, offset=(0, 8)

3. HEADER
   - Título: "TIENDA" (42px, color 0.5, 0.3, 0.6)
   - Subtítulo: "Mejora tus habilidades" (16px)

4. PANEL DE DINERO
   - Tamaño: 250x70
   - Icono: 🌿 (36px)
   - Texto: "0 Catnip" (28px, color 0.4, 0.6, 0.3)
   - Fondo: Color (0.95, 0.95, 0.7) con alpha 0.9

5. ITEMS DE MEJORA (2 items)
   - Panel por item: 650x100
   - Emoji único: ⚡ (velocidad) o 🎒 (bolsa)
   - Nombre: "Botas Rápidas" o "Bolsa Grande"
   - Descripción: pequeña
   - Nivel: "Nivel X/5" o "NIVEL MÁXIMO"
   - Botón compra: "XXX\nComprar" o "MÁXIMO"

6. BOTONES INFERIORES
   - "IR A NIVEL 2" → Cambiar a Main.tscn
   - "CERRAR" → Cerrar tienda

DATOS DE MEJORAS:
Velocidad:
  - precio_base: 50
  - incremento: 1.5
  - max_nivel: 5
  - color: (0.9, 0.85, 0.6)

Capacidad de bolsa:
  - precio_base: 75
  - incremento: 1.4
  - max_nivel: 5
  - color: (0.85, 0.9, 0.95)

PAUSA:
- get_tree().paused = true en _ready()
- get_tree().paused = false en cerrar
```

---

## INTERACCIÓN - DIÁLOGOS Y NPCS

### NPC Shop Cat (Don Bigotes)
```
ARCHIVO: /home/user/micho-farm-2/michov3/micho/scenes/characters/shop_cat.gd
ESCENA: /home/user/micho-farm-2/michov3/micho/scenes/tienda/gati.tscn
ESTADO: ✅ IMPLEMENTADO

COMPONENTES:
- AnimatedSprite2D: $Sprite2D
- InteractableComponent: $InteractableComponent
- Label de interacción: $InteractionLabel

INTERACCIÓN:
- Señal: interactable_activated / interactable_deactivated
- Label: "E - Hablar" (tamaño 12, color blanco con sombra)
- Tecla: "interact" (E por defecto)

FLUJO:
1. Jugador se acerca → Label visible
2. Presiona E → _open_shop()
3. Busca Dialogic → Inicia diálogo "tienda_dialogo"
4. Espera timeline_ended → Abre UI de tienda

MÉTODO:
```
_open_shop():
  - Verifica si existe Dialogic
  - Inicia diálogo: Dialogic.start("tienda_dialogo")
  - Espera: await Dialogic.timeline_ended
  - Abre: _abrir_ui_tienda()
```

DIALOGIC:
- Timeline: "tienda_dialogo" (no ubicado en búsqueda)
- Framework: Dialogic (addon completo)
- Estado: Sistema presente pero timelines no encontrados
```

### Sistema de Diálogos Global
```
ARCHIVO PRINCIPAL: /home/user/micho-farm-2/michov3/micho/scenes/main/main.gd
LINEAS: 13
ESTADO: ⚠️ BÁSICO

CONTENIDO:
- _ready():
  * Dialogic.start("intro_historia")
  * Conecta: Dialogic.timeline_ended.connect(_on_intro_terminada)
  * AudioManager.play_music("juego")

- _on_intro_terminada():
  * print("Introducción terminada")

TIMELINES USADOS:
- "intro_historia" ❌ NO ENCONTRADO EN BÚSQUEDA
- "tienda_dialogo" ❌ NO ENCONTRADO EN BÚSQUEDA

NOTA: Dialogic está instalado pero los archivos de timeline
      pueden estar en otra ruta o formato que no fue detectado.
```

---

## MÚSICA Y AUDIO

### Archivo de Música
```
✅ /home/user/micho-farm-2/michov3/micho/audio/musica/1_new_life_master.mp3
✅ /home/user/micho-farm-2/michov3/micho/audio/musica/1_new_life_master.mp3.import

TRACK NAME EN CÓDIGO: "juego"
REPRODUCCIÓN: play_music("juego", fade_in=true)
DURACIÓN: Desconocida (verificar en editor)
```

### Efectos de Sonido - FALTAN
```
❌ /home/user/micho-farm-2/michov3/micho/audio/sfx/click.ogg
❌ /home/user/micho-farm-2/michov3/micho/audio/sfx/plant.ogg
❌ /home/user/micho-farm-2/michov3/micho/audio/sfx/harvest.ogg
❌ /home/user/micho-farm-2/michov3/micho/audio/sfx/scare.ogg
❌ /home/user/micho-farm-2/michov3/micho/audio/sfx/points.ogg

DIRECTORIO: Carpeta sfx no existe aún
SISTEMA: Está implementado en audio_manager.gd pero falta audio
```

### Archivos de Ejemplo (Del addon Dialogic)
```
⚠️ /home/user/micho-farm-2/michov3/micho/addons/dialogic/Example Assets/sound-effects/typing1.wav
⚠️ /home/user/micho-farm-2/michov3/micho/addons/dialogic/Example Assets/sound-effects/typing2.wav
... (más archivos de ejemplo)

NOTA: Solo son ejemplos del addon, no son parte del juego
```

---

## RESUMEN DE UBICACIONES CRÍTICAS

| Sistema | Archivo Principal | Tipo | Estado |
|---------|------------------|------|--------|
| Audio | audio_manager.gd | Script | ✅ Listo |
| Música | 1_new_life_master.mp3 | Audio | ✅ Presente |
| SFX | audio/sfx/*.ogg | Audio | ❌ Falta crear |
| Movimiento | player.gd | Script | ✅ Completo |
| Enemigos | enemy.gd | Script | ✅ Funcional |
| Plantas | plant.gd | Script | ✅ Funcional |
| Puntuación | game_manager.gd | Script | ✅ Funcional |
| Menú | main_menu.gd | Script | ✅ Kawaii |
| Tienda | tienda_ui.gd | Script | ✅ Funcional |
| NPCs | shop_cat.gd | Script | ✅ Básico |
| Diálogos | Dialogic addon | Framework | ⚠️ Parcial |
| Partículas | scare_particles.tscn | Escena | ✅ Implementadas |
| Iluminación | (ninguno) | - | ❌ No existe |
| Parallax | (ninguno) | - | ❌ No existe |

