# 🏪 GUÍA PASO A PASO: Sistema de Tienda Interactiva

Esta guía te ayudará a crear un sistema completo de tienda donde el jugador puede entrar a un edificio, interactuar con un NPC gatito, y comprar mejoras.

---

## 📋 RESUMEN DEL SISTEMA

1. **Nivel 1 completado** → La tienda se desbloquea
2. **Edificio de tienda** aparece en el mapa (Free_Chicken_House.png)
3. **Jugador entra** a la puerta → Cambia a escena interior
4. **Interior de tienda** → Mapa con NPC gatito
5. **Interacción con gatito** → Se abre UI de tienda
6. **Compra mejoras** → Cierra UI y sigue en la tienda
7. **Sale de la tienda** → Vuelve al mapa principal

---

## ✅ ARCHIVOS YA CREADOS

Ya he creado estos scripts por ti:
- `scenes/characters/shop_cat.gd` - NPC gatito que abre la tienda
- `scenes/houses/shop_door.gd` - Puerta que cambia a interior
- `scenes/tienda/tienda_ui.gd` - UI de tienda como overlay
- Modificaciones en `SceneManager` y `GameManager`

---

## 🎮 PASO 1: CREAR ESCENA INTERIOR DE LA TIENDA

### 1.1 Crear nueva escena en Godot

1. En Godot, ve a: **Scene → New Scene**
2. Selecciona **Node2D** como nodo raíz
3. Renombra el nodo a `TiendaInterior`
4. Guarda la escena en: `scenes/tienda/tienda_interior.tscn`

### 1.2 Añadir TileMapLayer para el suelo

1. Click derecho en `TiendaInterior` → **Add Child Node**
2. Busca y añade: `TileMapLayer`
3. Renómbralo a `Suelo`

### 1.3 Configurar TileSet para el suelo

1. Selecciona el nodo `Suelo`
2. En el **Inspector**, busca la propiedad `Tile Set`
3. Click en `<empty>` → **New TileSet**
4. Click en el TileSet recién creado para editarlo
5. En el panel inferior (TileSet Editor), busca el botón **+** (Add TileSet Atlas Source)
6. Navega a: `assets/game/tilesets/Grass.png` o `neko-office-tileset.png`
7. Se abrirá la configuración:
   - **Texture Region Size**: Debería detectar automáticamente (16x16 o similar)
   - Click **OK**

### 1.4 Pintar el suelo

1. Con el nodo `Suelo` seleccionado
2. En el panel inferior verás las tiles disponibles
3. Selecciona un tile de piso/suelo
4. En el viewport (pantalla del juego), arrastra para pintar
5. Crea una habitación de aproximadamente **15x10 tiles**

**Tip**: Usa el botón de "Rectangle" en la barra de herramientas del TileMap para pintar áreas grandes más rápido.

### 1.5 Añadir TileMapLayer para las paredes

1. Click derecho en `TiendaInterior` → **Add Child Node**
2. Añade otro `TileMapLayer`
3. Renómbralo a `Paredes`
4. Asigna el mismo TileSet que usaste para el suelo (o usa `Wooden_House_Walls_Tilset.png`)
5. Selecciona tiles de pared y pinta el perímetro de tu habitación

### 1.6 Añadir decoración (opcional)

1. Añade otro `TileMapLayer` llamado `Decoracion`
2. Usa tiles de muebles, estantes, etc. del tileset
3. Decora el interior de la tienda

---

## 🐱 PASO 2: AÑADIR EL NPC GATITO

### 2.1 Crear escena del gatito

1. **Scene → New Scene**
2. Selecciona `CharacterBody2D` como raíz
3. Renombra a `ShopCat`

### 2.2 Añadir Sprite

Tienes dos opciones:

**Opción A - Sprite simple (más fácil):**
1. Add Child Node → `Sprite2D`
2. En Inspector, arrastra cualquier imagen de gato que tengas a la propiedad `Texture`
3. Ajusta el scale si es muy grande/pequeño

**Opción B - Sprite animado (recomendado si tienes spritesheet):**
1. Add Child Node → `AnimatedSprite2D`
2. En Inspector → `Sprite Frames` → `New SpriteFrames`
3. Click en el SpriteFrames para editarlo
4. En el panel inferior:
   - Click en `default`
   - Arrastra una imagen de gato
   - Si quieres animación idle, añade más frames

### 2.3 Añadir CollisionShape2D

1. Add Child Node (hijo de ShopCat) → `CollisionShape2D`
2. En Inspector → `Shape` → **New RectangleShape2D** o **New CircleShape2D**
3. Ajusta el tamaño en el viewport para que cubra el sprite

### 2.4 Añadir InteractableComponent

1. Ve a: `scenes/components/InteractableComponent.tscn`
2. Arrastra ese archivo al nodo `ShopCat` (instanciar como hijo)
3. Selecciona el `InteractableComponent` en el árbol de nodos
4. Expande para ver su `CollisionShape2D`
5. Ajusta el tamaño del área de interacción (hazla un poco más grande que el gatito)

### 2.5 Añadir Label para interacción

1. Add Child Node (hijo de ShopCat) → `Label`
2. Renombra a `InteractionLabel`
3. En Inspector:
   - Text: "E - Hablar"
   - Position: Ajusta en Y para que quede arriba del gatito (ej: Y = -40)
4. En el editor visual, muévelo para que se vea bien

### 2.6 Añadir el script

1. Selecciona el nodo `ShopCat`
2. Click en el ícono de script (junto al nombre) → **Attach Script**
3. En Path, navega a: `res://scenes/characters/shop_cat.gd`
4. Click **OK**

### 2.7 Configurar referencias (Onready)

El script ya tiene estas líneas, pero debes verificar que los nombres coincidan:

```gdscript
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: InteractableComponent = $InteractableComponent
@onready var interaction_label: Label = $InteractionLabel
```

Si usaste `Sprite2D` en lugar de `AnimatedSprite2D`, cambia la primera línea o comenta la animación.

### 2.8 Guardar escena del gatito

1. **File → Save Scene**
2. Guarda en: `scenes/characters/shop_cat.tscn`

---

## 🚪 PASO 3: AÑADIR PUERTA DE SALIDA EN INTERIOR

### 3.1 Añadir puerta a la escena interior

1. Abre `scenes/tienda/tienda_interior.tscn`
2. En Scene Tree, click derecho en `TiendaInterior` → **Instantiate Child Scene**
3. Navega a: `scenes/houses/door.tscn`
4. Coloca la puerta en la parte inferior del mapa (donde saldrá el jugador)

### 3.2 Modificar script de la puerta para que regrese

1. Selecciona la puerta que acabas de añadir
2. En Inspector, busca la sección **Script Variables** (o click en el ícono de script)
3. Modifica el script de esta puerta específica para que cambie de escena al salir

**Crea un nuevo script `exit_door.gd`:**

```gdscript
extends "res://scenes/houses/door.gd"

# Puerta de salida que regresa al mapa principal

func on_interactable_activated():
	super.on_interactable_activated()

	# Esperar un poco para la animación
	await get_tree().create_timer(0.3).timeout

	# Regresar a la escena anterior
	if SceneManager.player_data.last_scene != "":
		get_tree().change_scene_to_file(SceneManager.player_data.last_scene)
	else:
		get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
```

Guarda este script en `scenes/houses/exit_door.gd` y asígnalo a la puerta de salida.

---

## 🎯 PASO 4: AÑADIR JUGADOR AL INTERIOR

### 4.1 Añadir punto de spawn

1. En `scenes/tienda/tienda_interior.tscn`
2. Add Child Node → `Marker2D`
3. Renombra a `SpawnPoint`
4. Colócalo cerca de donde quieres que aparezca el jugador (cerca de la puerta de entrada)

### 4.2 Añadir el jugador

1. Instantiate Child Scene → Navega a `scenes/characters/player/player.tscn`
2. Coloca el jugador en el `SpawnPoint`

**IMPORTANTE**: El jugador debe poder moverse libremente en el interior.

---

## 🏠 PASO 5: AÑADIR GATITO AL INTERIOR

### 5.1 Instanciar el gatito

1. En `scenes/tienda/tienda_interior.tscn`
2. Instantiate Child Scene → `scenes/characters/shop_cat.tscn`
3. Coloca al gatito en el centro de la tienda o en un mostrador

### 5.2 Configurar grupos (importante)

1. Selecciona el nodo del jugador
2. En Inspector → Pestaña **Node**
3. En **Groups**, añade el grupo: `player`

---

## 🌍 PASO 6: AÑADIR EDIFICIO DE TIENDA AL MAPA PRINCIPAL

### 6.1 Abrir la escena del mapa principal

1. Abre la escena donde está tu nivel 1 (probablemente `scenes/main/Main.tscn`)

### 6.2 Añadir el sprite del edificio

1. Add Child Node → `Sprite2D`
2. Renombra a `ShopBuilding`
3. En Inspector → Texture:
   - Arrastra: `assets/game/objects/Free_Chicken_House.png`
4. Coloca el edificio en un lugar visible del mapa

### 6.3 Crear la puerta de entrada

1. **Scene → New Scene**
2. Root: `StaticBody2D`
3. Renombra a `ShopEntrance`

### 6.4 Configurar la puerta

1. Add Child Node → `AnimatedSprite2D` (o `Sprite2D` si prefieres sin animación)
2. Add Child Node → `CollisionShape2D`
   - Shape: RectangleShape2D
   - Ajusta el tamaño para cubrir la puerta
3. Instantiate Child Scene → `scenes/components/InteractableComponent.tscn`
   - Ajusta su área de colisión
4. Add Child Node → `Label` (renombra a `InteractionLabel`)

### 6.5 Añadir script a la puerta

1. Selecciona `ShopEntrance`
2. Attach Script → Selecciona `res://scenes/houses/shop_door.gd`

### 6.6 Configurar la ruta de la escena interior

1. Con `ShopEntrance` seleccionado
2. En Inspector, busca **Script Variables**
3. Verás: `Interior Scene Path`
4. Escribe: `res://scenes/tienda/tienda_interior.tscn`

### 6.7 Guardar y colocar en el mapa

1. Guarda la escena: `scenes/houses/shop_entrance.tscn`
2. En tu escena Main, instancia `shop_entrance.tscn`
3. Colócala en frente del sprite del edificio (Free_Chicken_House)

---

## 🎨 PASO 7: CREAR LA ESCENA DE UI

### 7.1 Crear escena de UI

1. **Scene → New Scene**
2. Root: `CanvasLayer`
3. Renombra a `TiendaUI`
4. Attach Script → Selecciona `res://scenes/tienda/tienda_ui.gd`
5. Guarda en: `scenes/tienda/tienda_ui.tscn`

**IMPORTANTE**: Esta escena debe tener SOLO el CanvasLayer como raíz. El resto se genera por código.

---

## ⚙️ PASO 8: CONFIGURAR INPUT MAP

Necesitas que el jugador pueda interactuar con "E":

1. **Project → Project Settings**
2. Ve a la pestaña **Input Map**
3. Busca si existe `interact`
4. Si no existe:
   - En "Add New Action", escribe: `interact`
   - Click **Add**
   - Click en el **+** al lado de `interact`
   - Presiona la tecla **E**
   - Click **OK**

---

## 🧪 PASO 9: PROBAR EL SISTEMA

### 9.1 Orden de pruebas

1. **Inicia el juego**
2. **Completa el nivel 1** (planta las plantas necesarias)
3. **Observa el mensaje**: "¡La tienda ha sido desbloqueada!"
4. **Vuelve al mapa** (botón reiniciar o lo que tengas configurado)
5. **Busca el edificio Free_Chicken_House**
6. **Acércate a la puerta** → Debe decir "E - Entrar a la tienda"
7. **Presiona E** → Cambia a la escena interior
8. **Muévete hacia el gatito** → Debe aparecer "E - Hablar"
9. **Presiona E** → Se abre la UI de tienda
10. **Compra algo** o presiona **CERRAR** o **ESC**
11. **Vuelve a la puerta de salida** → Presiona E para salir

### 9.2 Posibles problemas y soluciones

| Problema | Solución |
|----------|----------|
| "La tienda aún está cerrada" | Asegúrate de haber completado el nivel 1 primero |
| No se abre la UI al hablar con el gatito | Verifica que existe `tienda_ui.tscn` y que tiene el script correcto |
| El juego crashea al entrar | Revisa que `interior_scene_path` en la puerta apunte a la ruta correcta |
| El jugador no se mueve en el interior | Verifica que el jugador tiene su script y está en el grupo "player" |
| No aparece "E - Hablar" | Revisa que InteractableComponent tenga su CollisionShape2D configurado |
| El ESC no cierra la tienda | Verifica que `ui_cancel` existe en Input Map (Project Settings) |

---

## 📝 NOTAS ADICIONALES

### Personalización

- **Cambiar el gatito**: Usa cualquier sprite de gato que tengas en los assets
- **Decorar la tienda**: Usa el tileset neko-office-tileset.png que tiene muebles de oficina/tienda
- **Añadir más NPCs**: Duplica shop_cat.tscn y modifica el diálogo
- **Cambiar edificio**: Usa "The Old Shop.png" en lugar de Free_Chicken_House si prefieres

### Assets disponibles

Estos son los assets que tienes disponibles:
- **Edificios**: Free_Chicken_House.png, The Old Shop.png
- **Tilesets interiores**: neko-office-tileset.png, Wooden_House_Walls_Tilset.png
- **Decoración**: Puedes usar tiles del Sprout Lands UI Pack

### Desbloqueo manual (para pruebas)

Si quieres probar la tienda sin completar el nivel, añade esto temporalmente al código:

```gdscript
# En scenes/mainmenu/main_menu.gd, función _ready():
func _ready():
	SceneManager.player_data.shop_unlocked = true  # Añadir esta línea
	SceneManager.player_data.catnip = 500  # Dar dinero para probar
	# ... resto del código
```

---

## 🎉 ¡LISTO!

Siguiendo estos pasos deberías tener un sistema completo de tienda interactiva.

Si tienes problemas en algún paso específico, avísame y te ayudo a resolverlo.

**¡Buena suerte con tu juego! 🌸**
