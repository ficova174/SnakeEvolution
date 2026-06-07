extends Head


@onready var raycast_container = $RayCastContainer
@onready var raycasts: Array[RayCast2D] = [$RayCastContainer/RayCast2D]

@export var number_rays: int = 50
@export var fov: float = 270.0

@onready var camera := $Camera2D


func _ready() -> void:
	var raycast_template: RayCast2D = raycasts[0]
	var angle_step: float = fov / float(number_rays - 1)
	raycasts.clear() # to avoid duplicating the central ray
	for i in range(number_rays):
		var new_raycast: RayCast2D = raycast_template.duplicate()
		new_raycast.rotation_degrees = -(fov / 2.0) + i * angle_step
		raycast_container.add_child(new_raycast)
		raycasts.append(new_raycast)

func _physics_process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if not camera.is_current():
		return
	var width: int = 2
	for raycast in raycasts:
		if not raycast.is_colliding():
			var rotated_target_position: Vector2 = raycast.target_position.rotated(raycast.rotation)
			draw_line(Vector2.ZERO, rotated_target_position, Color.WHITE, width)
			continue
		var collider: Object = raycast.get_collider()
		var target_position: Vector2 = to_local(raycast.get_collision_point())
		if collider is Food:
			draw_line(Vector2.ZERO, target_position, Color.DARK_GREEN, width)
		elif collider is Head:
			draw_line(Vector2.ZERO, target_position, Color.DARK_ORANGE, width)
		elif collider is BodySegment:
			draw_line(Vector2.ZERO, target_position, Color.DARK_RED, width)
