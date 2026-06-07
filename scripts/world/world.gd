extends Node2D


@onready var down_border = $Borders/DownBorder
@onready var right_border = $Borders/RightBorder

@onready var map = $MapSprite2D
@onready var camera = $Camera2D
@onready var player = $Player

@export var food_counter: FoodCounter
@export var big_food_scene: PackedScene
@export var small_food_scene: PackedScene


func _ready() -> void:
	down_border.position = Vector2.DOWN * map.CELL_SIZE * map.height
	right_border.position = Vector2.RIGHT * map.CELL_SIZE * map.width

	player.exit_snake.connect(_on_exit_snake)
	player.snake_died.connect(_on_snake_died)

	food_counter.setMaxFoodMass(100)
	spawn_small_food()

func _on_exit_snake(camera_center: Vector2, camera_zoom: Vector2) -> void:
	camera.position = camera_center
	camera.zoom = camera_zoom
	camera.make_current()
	camera.reset_smoothing()

func _on_snake_died() -> void:
	for body_segment in player.body_segments:
		var big_food: Food = big_food_scene.instantiate()
		big_food.position = body_segment.global_position
		call_deferred("add_child", big_food)

func _physics_process(_delta: float) -> void:
	spawn_small_food()

func spawn_small_food() -> void:
	while food_counter.food_mass < food_counter.max_food_mass:
		var small_food: Food = small_food_scene.instantiate()
		small_food.position = Vector2(
			randf_range(0.0, map.width * map.CELL_SIZE),
			randf_range(0.0, map.height * map.CELL_SIZE)
		)
		add_child(small_food)
		food_counter.increment(small_food.mass)
