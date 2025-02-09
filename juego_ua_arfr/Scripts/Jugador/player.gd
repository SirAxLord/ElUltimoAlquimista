extends CharacterBody2D

func _physics_process(delta):
	velocity = Vector2(0, 0)

	if Input.is_action_pressed("ui_right"):
		velocity.x = 200
	if Input.is_action_pressed("ui_left"):
		velocity.x = -200
	#if Input.is_action_pressed("ui_up"):
	#	velocity.y = -200
	#if Input.is_action_pressed("ui_down"):
	#	velocity.y = 200
		
	move_and_slide()
