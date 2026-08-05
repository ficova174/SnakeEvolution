extends Node2D


@onready var map: Sprite2D = $MapSprite2D
@onready var camera: Camera2D = $Camera2D

@onready var down_border: CollisionShape2D = $Borders/DownBorder
@onready var right_border: CollisionShape2D = $Borders/RightBorder

@export var food_counter: Resource
@export var big_food_scene: PackedScene
@export var small_food_scene: PackedScene


@export var select_n_bests: int = 10
@export var food_tile_ratio: int = 10


func _ready() -> void:
	down_border.position = Vector2.DOWN * map.CELL_SIZE * map.height
	right_border.position = Vector2.RIGHT * map.CELL_SIZE * map.width

	food_counter.setMaxFoodMass(map.width * map.height / food_tile_ratio)
	spawn_small_food()

func _on_snake_exit(camera_center: Vector2, camera_zoom: Vector2) -> void:
	camera.position = camera_center
	camera.zoom = camera_zoom
	camera.make_current()
	camera.reset_smoothing()

func _on_snake_died(snake: Snake) -> void:
	for body_segment in snake.body_segments:
		var big_food: Food = big_food_scene.instantiate()
		big_food.position = body_segment.global_position
		call_deferred("add_child", big_food)

func spawn_bests_agents() -> void:
	var random_agent_selected: int = randi() % min(select_n_bests, leaderboard.agent_array.size())
	var parent_agent: Agent = leaderboard.agent_array[random_agent_selected]
	spawn_mutated_copy(parent_agent)

func spawn_mutated_copy(parent_agent: Agent) -> void:
	var new_agent = agent_scene.instantiate()
	var mutated_brain = parent_agent.head.brain.clone()
	mutated_brain.mutate()
	new_agent.mutated_brain = mutated_brain
	spawn_snake(new_agent)

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
