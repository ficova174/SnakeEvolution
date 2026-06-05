extends Node2D


@onready var down_border = $Borders/DownBorder
@onready var right_border = $Borders/RightBorder

@onready var map = $MapSprite2D
@onready var camera = $Camera2D
@onready var player = $Player

@export var big_food_scene: PackedScene
@export var small_food_scene: PackedScene

var max_food: int = 100
var small_food_quantity: int = 0


func _ready() -> void:
	down_border.position = Vector2.DOWN * map.CELL_SIZE * map.height
	right_border.position = Vector2.RIGHT * map.CELL_SIZE * map.width

	player.exit_snake.connect(_on_exit_snake)
	player.snake_died.connect(_on_snake_died)

	spawn_small_food()

func _on_exit_snake(camera_center: Vector2, camera_zoom: Vector2) -> void:
	camera.position = camera_center
	camera.zoom = camera_zoom
	camera.make_current()
	camera.reset_smoothing()

func _on_snake_died() -> void:
	for body_segment in player.body_segments:
		var food: Food = big_food_scene.instantiate()
		food.position = body_segment.global_position
		call_deferred("add_child", food)

func _physics_process(_delta: float) -> void:
	spawn_small_food()

func spawn_small_food() -> void:
	while small_food_quantity < max_food:
		var small_food: Food = small_food_scene.instantiate()
		small_food.position = Vector2(
			randf_range(0.0, map.width * map.CELL_SIZE),
			randf_range(0.0, map.height * map.CELL_SIZE)
		)
		add_child(small_food)
		small_food_quantity += 1
