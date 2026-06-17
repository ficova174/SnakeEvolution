extends CanvasLayer


@onready var agent: Agent = get_parent()
var head: Head
var vision: Node2D

@onready var mass_value: Label = %MassValue
@onready var score_value: Label = %ScoreValue
@onready var number_rays: Label = %NumberRays
@onready var fov_value: Label = %FOVValue

@onready var ray_vision_container = %RayVisionContainer
@export var ray_vision_container_height: float = 50.0
var rays_array: Array[ColorRect] = []


func _ready() -> void:
	agent.ready.connect(_on_agent_ready)
	agent.mass_changed.connect(_on_mass_changed)
	agent.score_changed.connect(_on_score_changed)

	ray_vision_container.custom_minimum_size = Vector2(0, ray_vision_container_height)

func _on_agent_ready() -> void:
	vision = agent.head.vision
	number_rays.text = str(vision.number_rays)
	fov_value.text = str(vision.fov) + "°"

	spawn_agent_vision()
	vision.raycast_changed.connect(_on_raycast_changed)

func _on_mass_changed(new_mass: int) -> void:
	mass_value.text = str(new_mass)

func _on_score_changed(new_score: float) -> void:
	score_value.text = str(int(new_score))

func spawn_agent_vision() -> void:
	for i in range(vision.number_rays):
		var ray_rect: ColorRect = ColorRect.new()
		ray_rect.color = Color.WHITE
		ray_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		ray_vision_container.add_child(ray_rect)
		rays_array.append(ray_rect)

func _on_raycast_changed(colors: PackedColorArray) -> void:
	for i in range(colors.size()):
		rays_array[i].color = colors[i]
