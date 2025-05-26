class_name Goblin
extends CharacterBody2D

@export var speed := 100.0  # Velocidad horizontal para seguir al personaje
@export var gravity := 1000.0  # Fuerza de la gravedad
@export var max_fall_speed := 500.0  # Velocidad máxima al caer
@export var detection_range := 300  # Rango para detectar al personaje
@export var attack_range := 50.0  # Rango para atacar al personaje
@export var vida := 60  # Vida del goblin
@export var fuerza := 10  # Fuerza del ataque del goblin

@export var knockback_horizontal := 200.0
@export var knockback_vertical := -100.0
var en_knockback := false

var barra_vida  # Variable para referenciar la barra de vida
var player: Node2D = null  # Referencia al nodo del personaje
var is_attacking := false  # Indica si el goblin está atacando
var has_attacked := false  # Controla si ya hizo daño en el ataque actual

func _ready():
	# Buscar al personaje en el Árbol de Escena
	barra_vida = $ProgressBar  # Aquí referenciamos el ProgressBar en el árbol de nodos
	barra_vida.max_value = vida  # Configuramos el máximo de la barra según la vida inicial
	barra_vida.value = vida  # Inicializamos la barra con el valor de vida actual
	player = get_parent().get_node("Character")
	add_to_group("enemigos") #grupo de enemigos

func _physics_process(delta):
	animaciones()
	# Aplicar gravedad para que el enemigo caiga
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
		
	if en_knockback:
		# Durante el knockback, solo aplica movimiento por knockback (y gravedad)
		move_and_slide()
		return  # Salir para evitar mover normal

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
	has_attacked = false  # Permitir daño en este ataque
	velocity.x = 0  # Detener al goblin mientras ataca
	$AnimatedSprite2D.play("attack")  # Reproducir la animación de ataque
	$AttackSound.play()  # <- Reproducir sonido de ataque

func recibir_dano(dano,origen: Vector2 = Vector2.ZERO):
	vida -= dano
	barra_vida.value = vida
	print("Goblin recibió daño. Vida actual:", vida)

	if origen != Vector2.ZERO:
		aplicar_knockback(origen)

	if vida <= 0:
		morir()

func aplicar_knockback(origen: Vector2):
	en_knockback = true

	# Determinar dirección horizontal del knockback (alejado del origen del daño)
	var direccion = sign(global_position.x - origen.x)
	velocity.x = knockback_horizontal * direccion
	velocity.y = knockback_vertical

	var timer := Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.2  # Duración del knockback (igual que personaje)
	timer.connect("timeout", Callable(self, "_terminar_knockback"))
	timer.start()

func _terminar_knockback():
	en_knockback = false

func morir():
	print("El goblin ha muerto.")  # Mensaje de depuración
	queue_free()  # Elimina al goblin del juego

func _on_animated_sprite_2d_animation_finished():
		is_attacking = false  # Salir del estado de ataque

func _on_area_2d_body_entered(body):
	if is_attacking and not has_attacked:
		if body.name == "Character": 
			print("Daño al jugador por enemigo")
			if body.has_method("recibir_dano"):
				body.recibir_dano(fuerza, global_position)  # Resta vida al personaje
			#recibir_dano(body.fuerza)  # Hacer daño al goblin según la fuerza del personaje
			has_attacked = true

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
