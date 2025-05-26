class_name Malachar
extends CharacterBody2D

@export var speed := 150.0
@export var gravity := 1000.0
@export var max_fall_speed := 500.0
@export var detection_range := 300
@export var attack_range := 50.0
@export var jump_force := -500.0
@export var jump_cooldown := 2.0

@export var vida := 150
@export var fuerza := 20

@export var knockback_horizontal := 200.0
@export var knockback_vertical := -100.0
var en_knockback := false

var barra_vida
var player: Node2D = null
var is_attacking := false
var has_attacked := false
var last_jump_time := 0.0

func _ready():
	barra_vida = $ProgressBar
	barra_vida.max_value = vida
	barra_vida.value = vida
	player = get_parent().get_node("Character")
	add_to_group("enemigos")

func _physics_process(delta):
	animaciones()

	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	if en_knockback:
		move_and_slide()
		return

	if player and not is_attacking:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= attack_range:
			atacar()
		elif distance_to_player <= detection_range:
			var direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x * speed

			var current_time = Time.get_ticks_msec()
			if player.global_position.y < global_position.y - 50 and is_on_floor() and (current_time - last_jump_time > jump_cooldown * 1000):
				velocity.y = jump_force
				last_jump_time = current_time
		else:
			velocity.x = 0
	else:
		velocity.x = 0

	move_and_slide()

func atacar():
	is_attacking = true
	has_attacked = false
	velocity.x = 0
	$AnimatedSprite2D.play("ataque")

func recibir_dano(dano: int, origen: Vector2 = Vector2.ZERO):
	vida -= dano
	barra_vida.value = vida
	print("Malachar recibió daño. Vida actual:", vida)

	if origen != Vector2.ZERO:
		aplicar_knockback(origen)

	if vida <= 0:
		morir()

func aplicar_knockback(origen: Vector2):
	en_knockback = true
	var direccion = sign(global_position.x - origen.x)
	velocity.x = knockback_horizontal * direccion
	velocity.y = knockback_vertical

	var timer := Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.3
	timer.connect("timeout", Callable(self, "_terminar_knockback"))
	timer.start()

func _terminar_knockback():
	en_knockback = false

func morir():
	print("Malachar ha muerto.")
	queue_free()

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false

func _on_area_2d_body_entered(body):
	if is_attacking and not has_attacked:
		if body.name == "Character":
			if body.has_method("recibir_dano"):
				body.recibir_dano(fuerza, global_position)
			has_attacked = true

func animaciones():
	if is_attacking:
		return

	if is_on_floor():
		if velocity.x != 0:
			$AnimatedSprite2D.scale.x = 1 * sign(velocity.x)
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("jump")
