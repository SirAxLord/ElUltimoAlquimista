# El Último Alquimista

Proyecto de videojuego desarrollado con Godot Engine. El repositorio contiene escenas, scripts y recursos para un juego de plataformas/acción con selección de personajes, niveles, HUD de vidas/estado, ítems de mejora y menús principales, pausa y fin de partida.

## Visión General
- Objetivo: avanzar por niveles mientras se gestionan vidas y se interactúa con ítems que curan o mejoran al personaje; incluye enemigos predefinidos (goblin, orc, minotaur) y una cinemática.
- Motor: Godot (proyecto en `juego_ua_arfr/project.godot`).
- Plataforma: escritorio (Windows); el contenido es estándar de Godot, portable a otros SO.

## Características
- Menú principal, selección de personajes, pausa y pantallas de fin/muerte.
- Niveles múltiples (`Levels/level_1.tscn` a `level_7.tscn` y `level_prueba.tscn`).
- HUD de vidas e inventario (`Escenas/HUD`), barra de salud (`Levels/health_bar.gd`).
- Ítems de vida y mejoras de fuerza/velocidad (`Escenas/Items`, `item.gd`, `vida.gd`, `Items/fuerza.gd`, `Items/Speed.gd`).
- Enemigos y personajes con recursos gráficos (`Resources/Character`, `Sprite/*`).
- Cinemática (`Escenas/Cinematica/videoCinematica.tscn`) y script `video_cinematica.gd`.

## Estructura del Proyecto
- `juego_ua_arfr/project.godot`: archivo de proyecto Godot.
- `juego_ua_arfr/Escenas/`: escenas organizadas por categorías.
	- `Characters/`: cámaras y escenas de personajes (goblin, orc, minotaur).
	- `HUD/`: escenas de interfaz (inventario, vidas) y sus recursos.
	- `Escenario/`: plataformas, trampas y mapas de prueba.
	- `Items/`: escenas de ítems (vida, fuerza, velocidad).
	- `Menus/`: menús principal, pausa, selección de personajes, fin y muerte.
	- `Cinematica/`: escena de video de la cinemática.
- `juego_ua_arfr/Levels/`: escenas de niveles y scripts de lógica de nivel (`finjuego.gd`, `health_bar.gd`).
- `juego_ua_arfr/Scripts/`: scripts de UI y flujo (`menu.gd`, `personajes.gd`, `video_cinematica.gd`).
- `juego_ua_arfr/Resources/`: fondos, personajes, imágenes, ítems, música, textos, tilesets y video.
- `juego_ua_arfr/Sprite/`: sprites organizados por personaje.

## Flujo de Juego
- Inicio: `menu.gd` cambia a la escena de selección de personajes.
	- `Scripts/menu.gd`
		- `play`: `get_tree().change_scene_to_file("res://Escenas/personajes.tscn")`
		- `quit`: `get_tree().quit()`
- Selección de personajes: `personajes.gd` permite uno o dos jugadores y lleva a `Levels/level_prueba.tscn` (puede adaptarse a otros niveles).
- Niveles: escenas en `Levels/` con plataformas, enemigos y HUD.
- Cinemática: `Escenas/Cinematica/videoCinematica.tscn` controlada por `video_cinematica.gd`.
- Fin de juego: escenas en `Menus/menu_fin.tscn` y `Menus/menu_dead.tscn` según estado.

## Mecánicas e Ítems
- Vida/Curación: `item.gd` y `vida.gd` definen áreas recogibles que se muestran tras 10s y al colisionar con el personaje (`Character`) curan 25 puntos invocando `recibir_dano(-25)`. Tras recogerlos, se ocultan y desactivan su colisión.
- Mejoras: scripts `Escenas/Items/fuerza.gd` y `Escenas/Items/Speed.gd` (si aplican) para fuerza y velocidad; escenas `itemFuerza.tscn`, `itemSpeed.tscn`, `itemVida.tscn`.
- HUD: `Escenas/HUD/hud-vidas.tscn`, `hud-inventario.tscn` y recursos de corazón/ícono.

## Recursos Gráficos y Audio
- Personajes: `Resources/Character/*` (`goblin4x.png.import`, `orc4x.png.import`, etc.).
- Fondos: `Resources/Backgrounds/*` por nivel/escenario.
- Imágenes: `Resources/Imagen/*` para menús y pantallas.
- Música y Video: carpetas `Resources/Music/` y `Resources/Video/`.

## Requisitos
- Godot Engine 3.x o 4.x (ver configuración exacta en `project.godot`). Si el proyecto fue creado en 4.x, abrir con Godot 4 estable.
- Windows 10/11 u otro SO compatible.

## Cómo Ejecutar
1. Instala Godot acorde a la versión del proyecto.
2. Abre Godot y carga el proyecto desde `juego_ua_arfr/project.godot`.
3. Define la escena principal en el Project Settings si fuera necesario (menú principal en `Escenas/Menu_Principal.tscn` o `Escenas/menu.tscn`).
4. Ejecuta (`Play`) desde el editor.

## Controles (propuesta)
- Movimiento: flechas o `A/D`.
- Salto: `W` o `Espacio`.
- Pausa: `Esc`.
Nota: Ajusta a Input Map del proyecto según `project.godot`.

## Desarrollo y Scripts Clave
- `Scripts/menu.gd`: navegación desde menú principal.
- `Scripts/personajes.gd`: flujo de selección y carga de nivel.
- `item.gd` / `vida.gd`: lógica de aparición tardía y recogida de vida.
- `Levels/health_bar.gd`: barra de salud del jugador.
- `Levels/finjuego.gd`: lógica de fin de nivel/partida.

## Estructura de Niveles
- Niveles enumerados `level_1.tscn` a `level_7.tscn` y `level_prueba.tscn` para pruebas.
- Escenarios y plataformas en `Escenas/Escenario/` con trampas y plataformas (`Trap.tscn`, `Platform.tscn`).

## Personalización
- Añadir nuevos ítems: crear escena `itemXYZ.tscn` en `Escenas/Items` y script correspondiente.
- Añadir enemigos: crear escenas en `Escenas/Characters/` y vincular a niveles.
- Ajustar HUD: editar `Escenas/HUD/*` y scripts en `Levels/`.

## Contribuir
- Issues/PRs: describe cambios propuestos y pruebas realizadas.
- Estilo: mantener la organización por carpetas y nombres coherentes.
- Recursos: coloca assets en `Resources/*` y sprites en `Sprite/*`.

## Licencia
- No especificada en el repositorio. Añade una licencia (por ejemplo MIT o CC-BY para assets) según corresponda antes de distribuir.
