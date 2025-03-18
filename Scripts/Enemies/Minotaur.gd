class_name Minotaur
extends CharacterBody2D

const SPEED = 100.0
const MOVE_RANGE = 300.0  # Rango de movimiento más grande en el eje X
const RESPAWN_TIME = 2.0  # Tiempo de reaparición en segundos

var direction = Vector2()
var target = null

func _ready() -> void:
	# Establece una posición aleatoria inicial dentro del rango de movimiento
	position.x += randi() % int(MOVE_RANGE) - MOVE_RANGE / 2
	# Establece una dirección aleatoria inicial
	direction = Vector2(randi() % 2 * 2 - 1, 0)
	# Encuentra el nodo del personaje
	target = get_parent().get_node("Character")

func _physics_process(delta: float) -> void:
	if target != null:
		# Seguir al personaje
		direction.x = (target.position - position).normalized().x
		velocity.x = direction.x * SPEED
		move_and_slide()

		# Comprobar colisión con el personaje
		if position.distance_to(target.position) < 20.0 and is_on_floor():
			await enemy_dies()

func enemy_dies() -> void:
	# Desaparecer el enemigo
	queue_free()
	# Volver a generar el enemigo después de un tiempo
	await get_tree().create_timer(RESPAWN_TIME).timeout
	var new_enemy = Minotaur.new()
	get_parent().add_child(new_enemy)
	new_enemy.position = Vector2(randi() % int(MOVE_RANGE) - MOVE_RANGE / 2, position.y)
