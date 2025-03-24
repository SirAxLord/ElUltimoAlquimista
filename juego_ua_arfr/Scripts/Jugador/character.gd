class_name Character
extends CharacterBody2D

@export var speed := 200.0  # Velocidad horizontal máxima
@export var jump_force := -400.0  # Fuerza del salto
@export var gravity := 1000.0  # Gravedad personalizada

var can_double_jump := true  # Permite controlar si el personaje puede hacer doble salto
var is_attacking := false  # Indica si se está ejecutando la animación de ataque


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
	
	# Resetear el doble salto cuando el personaje está en el suelo
	if is_on_floor():
		can_double_jump = true
	
	# Detectar ataque al presionar space
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("ataque")

func _on_animated_sprite_2d_animation_finished():
		is_attacking = false

#Animaciones
func animaciones():
	if is_attacking: #si está atacando, no cambiar de animcacion
		return
	
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
