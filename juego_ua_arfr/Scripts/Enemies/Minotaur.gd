class_name Minotaur
extends CharacterBody2D

@export var speed := 120.0
@export var gravity := 1000.0
@export var max_fall_speed := 500.0
@export var detection_range := 300
@export var attack_range := 40.0
@export var vida := 120
@export var fuerza := 15

var barra_vida
var player: Node2D = null
var is_attacking := false

# NUEVAS VARIABLES DE RETROCESO
var knockback_speed := 180.0
var knockback_time := 0.2
var knockback_timer := 0.0
var knockback_direction := Vector2.ZERO

func _ready():
	barra_vida = $ProgressBar
	barra_vida.max_value = vida
	barra_vida.value = vida
	player = get_parent().get_node("Character")
	add_to_group("enemigos") #grupo de enemigos

func _physics_process(delta):
	animaciones()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	if knockback_timer > 0:
		# Aplicar retroceso en ambas direcciones
		velocity.x = knockback_direction.x * knockback_speed
		velocity.y = knockback_direction.y * knockback_speed
		knockback_timer -= delta
	else:
		if player and not is_attacking:
			var distance_to_player = global_position.distance_to(player.global_position)

			if distance_to_player <= attack_range:
				atacar()
			elif distance_to_player <= detection_range:
				var direction = (player.global_position - global_position).normalized()
				velocity.x = direction.x * speed
			else:
				velocity.x = 0
		else:
			velocity.x = 0

	move_and_slide()

func atacar():
	is_attacking = true
	velocity.x = 0
	$AnimatedSprite2D.play("attack")
	$AttackSound.play()  # <- Reproducir sonido de ataque

#  AÑADIDO RETROCESO AQUÍ
func recibir_dano(dano,origen: Vector2 = Vector2.ZERO):
	vida -= dano
	barra_vida.value = vida

	if vida <= 0:
		morir()
	else:
		if player:
			knockback_direction = (global_position - player.global_position).normalized()
			knockback_direction.y = -0.6  # Empuje vertical hacia arriba, ajustable
			knockback_direction = knockback_direction.normalized()
			knockback_timer = knockback_time

func morir():
	print("El Minotauro ha muerto.")
	queue_free()

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false

func _on_area_2d_body_entered(body):
	if body.name == "Character":
		if body.has_method("recibir_dano"):
			body.recibir_dano(fuerza, global_position)
		#recibir_dano(body.fuerza)

func animaciones():
	if is_attacking:
		return
	
	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.scale.x = 1 * sign(velocity.x)
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
