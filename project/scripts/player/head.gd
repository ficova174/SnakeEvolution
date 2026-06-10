extends Head


func _physics_process(delta: float) -> void:
	var delta_angle: float = Vector2.RIGHT.rotated(rotation).angle_to(get_global_mouse_position())
	rotation = move_toward(rotation, delta_angle, rotation_speed * delta)

	if Input.is_action_pressed("dash"):
		speed = move_toward(speed, max_speed, acceleration * delta)
	else:
		speed = move_toward(speed, min_speed, acceleration * delta)

	velocity = transform.x * speed
	move_and_slide()
