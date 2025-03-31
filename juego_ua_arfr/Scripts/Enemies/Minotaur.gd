class_name Minotaur
extends CharacterBody2D

@export var speed := 120.0  # Velocidad del Minotauro
@export var gravity := 1000.0  # Fuerza de gravedad
@export var max_fall_speed := 500.0  # Velocidad máxima de caída
@export var detection_range := 0  # Rango para detectar al personaje
@export var attack_range := 40.0  # Rango de ataque
@export var vida := 150  # Vida del Minotauro
@export var fuerza := 20  # Daño que inflige
@export var respawn_time := 3.0  # Tiempo de reaparición

var barra_vida
var player: Node2D = null
var is_attacking := false

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

func recibir_dano(dano):
	vida -= dano
	barra_vida.value = vida
	if vida <= 0:
		morir()

func morir():
	print("El Minotauro ha muerto.")
	queue_free()
	respawn()

func respawn():
	await get_tree().create_timer(respawn_time).timeout
	var new_minotaur = Minotaur.new()
	get_parent().add_child(new_minotaur)
	new_minotaur.position = global_position + Vector2(randf_range(-100, 100), 0)

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
