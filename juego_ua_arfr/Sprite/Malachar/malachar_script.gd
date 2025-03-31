class_name Malachar
extends CharacterBody2D

@export var speed := 200.0  # Velocidad horizontal máxima
@export var jump_force := -400.0  # Fuerza del salto
@export var gravity := 1000.0  # Gravedad personalizada
@export var max_fall_speed := 500.0  # Velocidad máxima al caer
@export var detection_range := 0.0  # Rango para detectar al personaje (mayor que el goblin)
@export var attack_range := 50.0  # Rango para atacar al personaje (mayor alcance)
@export var jump_cooldown := 2.0  # Tiempo mínimo entre cada salto
@export var vida := 120  # Vida del enemigo
@export var fuerza := 20  # Fuerza del ataque del enemigo

var can_double_jump := true  # Permite controlar si el personaje puede hacer doble salto

func _physics_process(delta):
	animaciones()
	# Detectar movimiento horizontal
	velocity.x = 0
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed

	# Aplicar gravedad si no estamos en el suelo
	if not is_on_floor():
		velocity.y += gravity * delta

 # Manejo del salto y doble salto
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():  # Si el personaje está en el suelo, salta normalmente
			velocity.y = jump_force
			can_double_jump = true  # Habilitar el doble salto después de un salto normal
		elif can_double_jump:  # Si no está en el suelo pero puede hacer doble salto
			velocity.y = jump_force
			can_double_jump = false  # Deshabilitar el doble salto hasta que vuelva al suelo

	# Mover al personaje con la propiedad integrada 'velocity'
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
	
	# Resetear el doble salto cuando el personaje está en el suelo
	if is_on_floor():
		can_double_jump = true
		
	
#Animaciones
func animaciones():
	if is_on_floor():
		if velocity.x !=0:
			$AnimatedSprite2D.scale.x = 1*sign(velocity.x)
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
