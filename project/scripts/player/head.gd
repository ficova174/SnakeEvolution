extends Head


func _physics_process(delta: float) -> void:
	var target_angle: float = global_position.direction_to(get_global_mouse_position()).angle()
	rotation = rotate_toward(rotation, target_angle, genome.rotation_speed * delta)

	if Input.is_action_pressed("dash"):
		speed = move_toward(speed, genome.max_speed, genome.acceleration * delta)
	else:
		speed = move_toward(speed, genome.min_speed, genome.acceleration * delta)

	velocity = transform.x * speed
	move_and_slide()
