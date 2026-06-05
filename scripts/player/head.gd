extends Head


func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("dash"):
		speed = move_toward(speed, max_speed, acceleration * delta)
	else:
		speed = move_toward(speed, min_speed, acceleration * delta)

	velocity = transform.x * speed
	move_and_slide()
