class_name Malachar
extends CharacterBody2D

@export var speed := 150.0  # Velocidad horizontal para seguir al personaje (más rápido que el goblin)
@export var jump_force := -500.0  # Fuerza del salto del jefe
@export var gravity := 1000.0  # Gravedad personalizada
@export var max_fall_speed := 500.0  # Velocidad máxima al caer
@export var detection_range := 300.0  # Rango para detectar al personaje (mayor que el goblin)
@export var attack_range := 50.0  # Rango para atacar al personaje (mayor alcance)
@export var jump_cooldown := 2.0  # Tiempo mínimo entre cada salto
@export var vida := 150  # Vida del enemigo
@export var fuerza := 20  # Fuerza del ataque del enemigo

var barra_vida  # Variable para referenciar la barra de vida
var player: Node2D = null  # Referencia al nodo del personaje
var is_attacking := false  # Indica si el goblin está atacando
var last_jump_time := 0.0  # Control del tiempo para saltar


func _ready():
	barra_vida = $ProgressBar
	barra_vida.max_value = vida
	barra_vida.value = vida
	player = get_parent().get_node("Character")

func _physics_process(delta):
	animaciones()

	# Aplicar gravedad para que Malachar caiga
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	if player and not is_attacking:  # Si el personaje existe y no está atacando
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_range:
			atacar()  # Activar ataque si está en rango
		elif distance_to_player <= detection_range:
			seguir_al_personaje(delta)  # Correr y saltar para seguir al personaje
		else:
			velocity.x = 0  # Detenerse si está fuera de rango
	else:
		velocity.x = 0  # No moverse si no hay personaje o está atacando

	move_and_slide()

func seguir_al_personaje(_delta):

	# Calcular la dirección hacia el personaje
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * speed

	# Obtener el tiempo actual en milisegundos
	var current_time = Time.get_ticks_msec()

	# Saltar si el jugador está por encima y ha pasado el cooldown
	if player.global_position.y < global_position.y - 50 and is_on_floor() and (current_time - last_jump_time > jump_cooldown * 1000):
		velocity.y = jump_force
		last_jump_time = current_time

func atacar():
	is_attacking = true
	velocity.x = 0  # Detener al goblin mientras ataca
	$AnimatedSprite2D.play("ataque")  # Reproducir la animación de ataque
	
func recibir_dano(dano):
	vida -= dano
	barra_vida.value = vida
	if vida <= 0:
		morir()

func morir():
	print("Malachar ha muerto.")
	queue_free()
	
func _on_animated_sprite_2d_animation_finished():
		is_attacking = false  # Salir del estado de ataque

func _on_area_2d_body_entered(body):
	if body.name == "Character":
		if body.has_method("recibir_dano"):
			body.recibir_dano(fuerza)
		recibir_dano(body.fuerza) # Puedes reemplazarlo con lógica de daño al jugador

func animaciones():
	if is_attacking:  # Si está atacando, no cambiar de animación
		return

	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.scale.x = 1 * sign(velocity.x)
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("jump")
