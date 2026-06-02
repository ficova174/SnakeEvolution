extends Camera2D


const CAMERA_SPEED: float = 500.0
const ZOOM_INCREMENT: float = 0.05
const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 20.0


func _unhandled_input(_event: InputEvent) -> void:
	zoom_camera()

func _process(delta: float) -> void:
	move_camera(delta)

func move_camera(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	position += CAMERA_SPEED * delta * direction

func zoom_camera() -> void:
	var direction1D: float = 0
	if Input.is_action_just_pressed("zoom_in"):
		direction1D = -1
	elif Input.is_action_just_pressed("zoom_out"):
		direction1D = 1
	zoom *= 1 + direction1D * ZOOM_INCREMENT
	zoom = zoom.clamp(Vector2.ONE * MIN_ZOOM, Vector2.ONE * MAX_ZOOM)
