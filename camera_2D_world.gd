extends Camera2D


const CAMERA_SPEED: float = 500.0
const ZOOM_SPEED: float = 5.0


func _process(delta: float) -> void:
	moveCamera(delta)
	zoomCamera(delta)

func moveCamera(delta) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	position += CAMERA_SPEED * delta * direction

func zoomCamera(delta) -> void:
	var direction1D = Input.get_axis("zoom_out", "zoom_in")
	zoom *= 1 + direction1D * ZOOM_SPEED * delta
	zoom.x = clampf(zoom.x, 1.0, 20.0)
	zoom.y = clampf(zoom.y, 1.0, 20.0)
