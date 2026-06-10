extends Node2D


@onready var down_border = $Borders/DownBorder
@onready var right_border = $Borders/RightBorder

@onready var map = $MapSprite2D
@onready var camera = $Camera2D

@export var food_counter: FoodCounter
@export var big_food_scene: PackedScene
@export var small_food_scene: PackedScene

@onready var snake_container = $SnakeContainer
@export var agent_scene: PackedScene
@export var player_scene: PackedScene


func _ready() -> void:
	down_border.position = Vector2.DOWN * map.CELL_SIZE * map.height
	right_border.position = Vector2.RIGHT * map.CELL_SIZE * map.width

	food_counter.setMaxFoodMass(100)
	spawn_small_food()

	spawn_agent()
	# spawn_player()

func spawn_agent() -> void:
	var agent = agent_scene.instantiate()
	spawn_snake(agent)

func spawn_player() -> void:
	var player = player_scene.instantiate()
	spawn_snake(player)

func spawn_snake(snake: Snake) -> void:
	snake.position = Vector2(
		randf_range(0.0, map.width * map.CELL_SIZE),
		randf_range(0.0, map.height * map.CELL_SIZE)
	)
	snake.exit_snake.connect(_on_exit_snake)
	snake.snake_died.connect(_on_snake_died)
	snake_container.add_child(snake)

func _on_exit_snake(camera_center: Vector2, camera_zoom: Vector2) -> void:
	camera.position = camera_center
	camera.zoom = camera_zoom
	camera.make_current()
	camera.reset_smoothing()

func _on_snake_died(snake: Snake) -> void:
	for body_segment in snake.body_segments:
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
