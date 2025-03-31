class_name Goblin
extends CharacterBody2D

@export var speed := 100.0  # Velocidad horizontal para seguir al personaje
@export var gravity := 1000.0  # Fuerza de la gravedad
@export var max_fall_speed := 500.0  # Velocidad máxima al caer
@export var detection_range := 0  # Rango para detectar al personaje
@export var attack_range := 50.0  # Rango para atacar al personaje
@export var vida := 60  # Vida del goblin
@export var fuerza := 10  # Fuerza del ataque del goblin
var barra_vida  # Variable para referenciar la barra de vida
var player: Node2D = null  # Referencia al nodo del personaje
var is_attacking := false  # Indica si el goblin está atacando

func _ready():
	# Buscar al personaje en el Árbol de Escena
	barra_vida = $ProgressBar  # Aquí referenciamos el ProgressBar en el árbol de nodos
	barra_vida.max_value = vida  # Configuramos el máximo de la barra según la vida inicial
	barra_vida.value = vida  # Inicializamos la barra con el valor de vida actual
	player = get_parent().get_node("Character")

func _physics_process(delta):
	animaciones()
	# Aplicar gravedad para que el enemigo caiga
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	if player and not is_attacking:  # Asegurarse de que el personaje existe y el goblin no está atacando
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_range:
			atacar()  # Si está en rango de ataque, activa el ataque
		elif distance_to_player <= detection_range:
			# Seguir al personaje si está dentro del rango de detección
			var direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x * speed
		else:
			# Fuera de rango, detener al goblin
			velocity.x = 0
	else:
		velocity.x = 0  # Sin movimiento si no hay personaje o está atacando

	move_and_slide()

func atacar():
	is_attacking = true
	velocity.x = 0  # Detener al goblin mientras ataca
	$AnimatedSprite2D.play("attack")  # Reproducir la animación de ataque

func recibir_dano(dano):
	vida -= dano
	barra_vida.value = vida  # Actualiza el ProgressBar con la vida restante
	if vida <= 0:
		morir()

func morir():
	print("El goblin ha muerto.")  # Mensaje de depuración
	queue_free()  # Elimina al goblin del juego

func _on_animated_sprite_2d_animation_finished():
		is_attacking = false  # Salir del estado de ataque

func _on_area_2d_body_entered(body):
	if body.name == "Character": 
		print("Daño al jugador por enemigo")
		if body.has_method("recibir_dano"):
			body.recibir_dano(fuerza)  # Resta vida al personaje
		recibir_dano(body.fuerza)  # Hacer daño al goblin según la fuerza del personaje
	
#Animaciones
func animaciones():
	if is_attacking:  # Si está atacando, no cambiar de animación
		return

	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.scale.x = 1 * sign(velocity.x)
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("Idle")
