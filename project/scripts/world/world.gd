extends Node2D


@onready var map: Sprite2D = $MapSprite2D
@onready var camera: Camera2D = $Camera2D

@onready var down_border: CollisionShape2D = $Borders/DownBorder
@onready var right_border: CollisionShape2D = $Borders/RightBorder

@export var food_counter: Resource
@export var big_food_scene: PackedScene
@export var small_food_scene: PackedScene

@export var agent_scene: PackedScene
@export var player_scene: PackedScene

@onready var snake_container: Node2D = $SnakeContainer

@onready var leaderboard: Node2D = $Leaderboard

@export var agent_counter: Resource

@export var select_n_bests: int = 10
@export var food_tile_ratio: int = 10


func _ready() -> void:
	down_border.position = Vector2.DOWN * map.CELL_SIZE * map.height
	right_border.position = Vector2.RIGHT * map.CELL_SIZE * map.width

	food_counter.setMaxFoodMass(map.width * map.height / food_tile_ratio)
	spawn_small_food()

	agent_counter.setMaxAgents(0)
	for i in range(agent_counter.max_agents):
		spawn_agent()
	# spawn_player()

func spawn_agent() -> void:
	var agent = agent_scene.instantiate()
	leaderboard.add_agent(agent)
	spawn_snake(agent)

func spawn_player() -> void:
	var player = player_scene.instantiate()
	spawn_snake(player)

func spawn_snake(snake: Snake) -> void:
	snake.position = Vector2(
		randf_range(0.0, map.width * map.CELL_SIZE),
		randf_range(0.0, map.height * map.CELL_SIZE)
	)
	snake.snake_exit.connect(_on_snake_exit)
	snake.snake_died.connect(_on_snake_died)
	snake_container.add_child(snake)

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

	if snake is Agent:
		spawn_bests_agents()
		leaderboard.remove_agent(snake)

func spawn_bests_agents() -> void:
	if leaderboard.agent_array.is_empty():
		return
	var random_agent_selected: int = randi() % min(select_n_bests, leaderboard.agent_array.size())
	var parent_agent: Agent = leaderboard.agent_array[random_agent_selected]
	spawn_mutated_copy(parent_agent)

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

func spawn_mutated_copy(parent_agent: Agent) -> void:
	var new_agent = agent_scene.instantiate()
	spawn_snake(new_agent)
	leaderboard.add_agent(new_agent)
	new_agent.head.brain = parent_agent.head.brain.clone()
	new_agent.head.brain.mutate()
