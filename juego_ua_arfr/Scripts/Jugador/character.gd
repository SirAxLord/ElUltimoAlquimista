class_name Character
extends CharacterBody2D

@export var speed := 200.0  # Velocidad horizontal máxima
@export var jump_force := -400.0  # Fuerza del salto
@export var gravity := 1000.0  # Gravedad personalizada
@export var vida := 100  # Vida del personaje
@export var fuerza := 15  # Fuerza del ataque del personaje

var barra_vida  # Variable para referenciar la barra de vida
var can_double_jump := true  # Permite controlar si el personaje puede hacer doble salto
var is_attacking := false  # Indica si se está ejecutando la animación de ataque

func _ready():
	barra_vida = $ProgressBar  # Aquí referenciamos el ProgressBar en el árbol de nodos
	barra_vida.max_value = vida  # Configuramos el máximo de la barra según la vida inicial
	barra_vida.value = vida  # Inicializamos la barra con el valor de vida actual

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

func recibir_dano(dano):
	vida -= dano
	barra_vida.value = vida  # Actualiza la barra de vida con el nuevo valor
	if vida <= 0:
		morir()
		
func morir():
	print("El jugador ha muerto.")  # Mensaje de depuración
	get_tree().change_scene_to_file("res://Escenas/Menus/menu_dead.tscn")  # Cambiar a la escena de muerte

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
