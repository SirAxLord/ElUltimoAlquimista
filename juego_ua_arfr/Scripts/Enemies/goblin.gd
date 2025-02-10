class_name Goblin
extends CharacterBody2D

const SPEED = 100.0
const MOVE_RANGE = 300.0  # Rango de movimiento más grande en el eje X

var direction = Vector2()

func _ready() -> void:
	# Establece una posición aleatoria inicial dentro del rango de movimiento
	position.x += randi() % int(MOVE_RANGE) - MOVE_RANGE / 2
	# Establece una dirección aleatoria inicial
	direction = Vector2(randi() % 2 * 2 - 1, 0)

func _physics_process(delta: float) -> void:
	# Movimiento en el eje X dentro del rango
	if direction.x > 0 and position.x > MOVE_RANGE / 2:
		direction.x = -1
	elif direction.x < 0 and position.x < -MOVE_RANGE / 2:
		direction.x = 1
	
	velocity.x = direction.x * SPEED

	move_and_slide()
