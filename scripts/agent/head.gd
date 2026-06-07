extends Head


@onready var raycast_container = $RayCastContainer
@onready var raycasts: Array[RayCast2D] = [$RayCastContainer/RayCast2D]
@export var number_rays: int = 10
@export var fov: float = 180.0


func _ready() -> void:
	var raycast_template: RayCast2D = raycasts[0]
	var angle_step: float = fov / float(number_rays - 1)
	for i in range(number_rays):
		var new_raycast: RayCast2D = raycast_template.duplicate()
		new_raycast.rotation_degrees = -(fov / 2.0) + i * angle_step
		raycast_container.add_child(new_raycast)
		raycasts.append(new_raycast)
