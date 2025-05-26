class_name Character
extends CharacterBody2D

@export var speed := 200.0  # Velocidad horizontal máxima
@export var jump_force := -400.0  # Fuerza del salto
@export var gravity := 1000.0  # Gravedad personalizada
@export var vida := 200  # Vida del personaje
@export var fuerza := 15  # Fuerza del ataque del personaje
@export var knockback_horizontal := 400.0  # Empuje horizontal fuerte
@export var knockback_vertical := -300.0   # Empuje vertical hacia arriba (negativo porque Y+ es hacia abajo)

var velocidad_base := speed  # Almacena la velocidad original del personaje
var barra_vida  # Variable para referenciar la barra de vida
var can_double_jump := true  # Permite controlar si el personaje puede hacer doble salto
var is_attacking := false  # Indica si se está ejecutando la animación de ataque
var fuerza_temporal := 0  # Valor temporal de aumento de fuerza
var en_knockback := false

func _ready():
	barra_vida = $ProgressBar  # Aquí referenciamos el ProgressBar en el árbol de nodos
	barra_vida.max_value = vida  # Configuramos el máximo de la barra según la vida inicial
	barra_vida.value = vida  # Inicializamos la barra con el valor de vida actual
	$AttackArea/CollisionShape2D.disabled = true  # Desactiva el área de ataque al inicio
	add_to_group("jugador")

func _physics_process(delta):
	animaciones()
	# Solo permitir movimiento del jugador si no está en knockback
	if not en_knockback:
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
		$AttackArea/CollisionShape2D.disabled = false  # Activar área de ataque
		$AnimatedSprite2D.play("ataque")
		$AttackSound.play()  # <- Reproducir sonido de ataque

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
	$AttackArea/CollisionShape2D.disabled = true  # Desactivar área de ataque

func _on_attack_body_entered(body):
	if is_attacking and body.is_in_group("enemigos"):
		var direccion = $AnimatedSprite2D.scale.x
		var diferencia_x = body.global_position.x - global_position.x
		
		if (direccion > 0 and diferencia_x > 0) or (direccion < 0 and diferencia_x < 0):
			body.recibir_dano(fuerza, global_position)  # <-- Enviamos la posición del personaje

func recibir_dano(dano, origen: Vector2 = Vector2.ZERO):
	vida -= dano  # Aplica el daño o curación
	if vida > barra_vida.max_value:  # Asegura que la vida no exceda el máximo
		vida = barra_vida.max_value
	if vida < 0:  # Evita que la vida sea negativa
		vida = 0

	barra_vida.value = vida  # Actualiza la barra de vida con el nuevo valor
	
	if origen != Vector2.ZERO:
		aplicar_knockback(origen)

	if vida <= 0:
		morir()

func aplicar_knockback(origen: Vector2):
	var direccion = sign(global_position.x - origen.x)
	velocity.x = knockback_horizontal * direccion
	velocity.y = knockback_vertical
	en_knockback = true  # Activamos el estado de retroceso

	var timer := Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.2  # Tiempo que dura el knockback
	timer.connect("timeout", Callable(self, "_terminar_knockback"))
	timer.start()
	
func _terminar_knockback():
	en_knockback = false


func incrementar_fuerza(aumento : int, duracion : float) -> void:
	fuerza += aumento  # Incrementa la fuerza
	fuerza_temporal = aumento  # Guarda el aumento temporal
	print("Fuerza aumentada:", fuerza)

	var timer := Timer.new()
	add_child(timer)  # Agregar el temporizador como hijo del personaje
	timer.one_shot = true
	timer.wait_time = duracion
	timer.connect("timeout", Callable(self, "_restaurar_fuerza"))
	timer.start()

func _restaurar_fuerza() -> void:
	fuerza -= fuerza_temporal  # Restaura la fuerza
	fuerza_temporal = 0  # Limpia el valor temporal
	print("Fuerza restaurada:", fuerza)

func incrementar_velocidad(multiplicador : float, duracion : float) -> void:
	speed *= multiplicador  # Multiplica la velocidad
	print("Velocidad aumentada:", speed)

	var timer := Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = duracion
	timer.connect("timeout", Callable(self, "_restaurar_velocidad"))
	timer.start()

func _restaurar_velocidad() -> void:
	speed = velocidad_base  # Restaura la velocidad original
	print("Velocidad restaurada:", speed)
		
func morir():
	print("El jugador ha muerto.")  # Mensaje de depuración
	get_tree().change_scene_to_file("res://Escenas/Menus/menu_dead.tscn")  # Cambiar a la escena de muerte

#Animaciones
func animaciones():
	if is_attacking:  # Si está atacando, no cambiar de animación
		return
	
	if is_on_floor():
		if velocity.x != 0:
			var direccion = sign(velocity.x)
			$AnimatedSprite2D.scale.x = direccion
		
			# Mover AttackArea según la dirección
			$AttackArea.position.x = abs($AttackArea.position.x) * direccion
			
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
