class_name Goblin
extends CharacterBody2D

@export var speed := 100.0  # Velocidad horizontal para seguir al personaje
@export var gravity := 1000.0  # Fuerza de la gravedad
@export var max_fall_speed := 500.0  # Velocidad máxima al caer

var player: Node2D = null  # Referencia al nodo del personaje

func _ready():
	# Buscar al personaje en el Árbol de Escena
	player = get_parent().get_node("Character")

func _physics_process(delta):
	animaciones()
	# Aplicar gravedad para que el enemigo caiga
	if not is_on_floor():
		velocity.y += gravity * delta
		# Limitar la velocidad de caída
		velocity.y = min(velocity.y, max_fall_speed)

	# Asegurarse de que player no sea null antes de usarlo
	if player:
		# Calcular la dirección hacia el personaje
		var direction = (player.global_position - global_position).normalized()

		# Mover al enemigo hacia el personaje solo en el eje X (horizontal)
		velocity.x = direction.x * speed
	else:
		# Si no hay un personaje, detener el movimiento horizontal
		velocity.x = 0

	# Mover al enemigo y manejar colisiones
	move_and_slide()

# Funcion para cuando el personaje entra en el area del enemigo
func _on_area_2d_body_entered(body):
	if body.name == "Character": 
		print("Daño al jugador por enemigo")
		enemigo_dañado()

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
	
	#Animaciones
func animaciones():
	if is_on_floor():
		if velocity.x !=0:
			$AnimatedSprite2D.scale.x = 1*sign(velocity.x)
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("Idle")
	#else:
		#if velocity.y < 0:
			#$AnimatedSprite2D.play("jump")
		#else:
			#$AnimatedSprite2D.play("fall")
