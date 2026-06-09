extends Camera2D


const ZOOM_INCREMENT: float = 0.05
const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 20.0


func _unhandled_input(_event: InputEvent) -> void:
	zoom_camera()

func zoom_camera() -> void:
	var direction1D: float = 0
	if Input.is_action_just_pressed("zoom_in"):
		direction1D = -1
	elif Input.is_action_just_pressed("zoom_out"):
		direction1D = 1
	zoom *= 1 + direction1D * ZOOM_INCREMENT
	zoom = zoom.clamp(Vector2.ONE * MIN_ZOOM, Vector2.ONE * MAX_ZOOM)
