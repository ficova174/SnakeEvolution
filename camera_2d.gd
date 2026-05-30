extends Camera2D


const camera_speed: float = 500.0
const zoom_speed: float = 5.0


func _process(delta: float) -> void:
	moveCamera(delta)
	zoomCamera(delta)

func moveCamera(delta) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1.0
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		direction.x += 1.0
	if Input.is_action_pressed("ui_down"):
		direction.y += 1.0
	position += camera_speed * delta * direction.normalized()

func zoomCamera(delta) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom *= 1 + zoom_speed * delta
	if Input.is_action_just_pressed("zoom_out"):
		zoom *= 1 - zoom_speed * delta
	zoom.x = clampf(zoom.x, 1.0, 20.0)
	zoom.y = clampf(zoom.y, 1.0, 20.0)
