extends CanvasLayer


@onready var agent: Agent = get_parent()
var head: Head

@onready var mass_value: Label = %MassValue
@onready var number_rays: Label = %NumberRays
@onready var fov_value: Label = %FOVValue

@onready var ray_vision_container = %RayVisionContainer
@export var ray_vision_container_height: float = 50.0


func _ready() -> void:
	agent.ready.connect(_on_agent_ready)
	agent.mass_changed.connect(_on_mass_changed)

	ray_vision_container.custom_minimum_size = Vector2(0, ray_vision_container_height)

func _on_agent_ready() -> void:
	head = agent.head
	number_rays.text = str(head.number_rays)
	fov_value.text = str(head.fov) + "°"

	spawn_agent_vision()

func _on_mass_changed(new_mass: int) -> void:
	mass_value.text = str(new_mass)

func spawn_agent_vision() -> void:
	for i in range(head.number_rays):
		var ray_rect: ColorRect = ColorRect.new()
		ray_rect.color = Color(1, 1, 1, 1)
		ray_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		ray_vision_container.add_child(ray_rect)
