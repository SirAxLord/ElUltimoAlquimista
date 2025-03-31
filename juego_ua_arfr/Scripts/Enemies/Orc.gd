class_name Orc
extends CharacterBody2D

@export var speed := 90.0  # Velocidad del Orc
@export var gravity := 1000.0  # Gravedad
@export var max_fall_speed := 500.0  # Velocidad máxima al caer
@export var detection_range := 0  # Rango para detectar al personaje
@export var attack_range := 35.0  # Rango de ataque
@export var vida := 100  # Vida del Orc
@export var fuerza := 15  # Daño del Orc

var barra_vida
var player: Node2D = null
var is_attacking := false
var direction := Vector2.LEFT

func _ready():
	barra_vida = $ProgressBar
	barra_vida.max_value = vida
	barra_vida.value = vida
	player = get_parent().get_node("Character")

func _physics_process(delta):
	animaciones()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	
	if player and not is_attacking:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player <= attack_range:
			atacar()
		elif distance_to_player <= detection_range:
			direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x * speed
		else:
			patrullar()
	
	move_and_slide()

func patrullar():
	if is_on_floor():
		velocity.x = direction.x * speed
		if position.x > 100:
			direction = Vector2.LEFT
		elif position.x < -100:
			direction = Vector2.RIGHT

func atacar():
	is_attacking = true
	velocity.x = 0
	$AnimatedSprite2D.play("attack")

func recibir_dano(dano):
	vida -= dano
	barra_vida.value = vida
	if vida <= 0:
		morir()

func morir():
	print("El Orc ha muerto.")
	queue_free()

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false

func _on_area_2d_body_entered(body):
	if body.name == "Character":
		if body.has_method("recibir_dano"):
			body.recibir_dano(fuerza)
		recibir_dano(body.fuerza)

func animaciones():
	if is_attacking:
		return
	
	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.scale.x = 1 * sign(velocity.x)
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
