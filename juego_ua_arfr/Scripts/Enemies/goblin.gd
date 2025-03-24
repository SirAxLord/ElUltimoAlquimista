class_name Goblin
extends CharacterBody2D

@export var speed := 100.0  # Velocidad horizontal para seguir al personaje
@export var gravity := 1000.0  # Fuerza de la gravedad
@export var max_fall_speed := 500.0  # Velocidad máxima al caer
@export var detection_range := 300.0  # Rango para detectar al personaje
@export var attack_range := 50.0  # Rango para atacar al personaje

var player: Node2D = null  # Referencia al nodo del personaje
var is_attacking := false  # Indica si el goblin está atacando

func _ready():
	# Buscar al personaje en el Árbol de Escena
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
	$AnimatedSprite2D.play("Ataque")  # Reproducir la animación de ataque

func _on_animated_sprite_2d_animation_finished():
		is_attacking = false  # Salir del estado de ataque

func enemigo_dañado():
	print("Enemigo eliminado")  # Imprime en la consola para depuración

	hide()  # Oculta al enemigo
	# Generar una posición aleatoria
	var random_position = Vector2(
		randf() * 1000.0,  # Rango en X (ajusta según tu nivel)
		randf() * 600.0    # Rango en Y (ajusta según tu nivel)
	)
	global_position = random_position  # Cambiar la posición
	show()  # Mostrar al enemigo de nuevo

# Funcion para cuando el personaje entra en el area del enemigo
func _on_area_2d_body_entered(body):
	if body.name == "Character": 
		print("Daño al jugador por enemigo")
		enemigo_dañado()
	
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
