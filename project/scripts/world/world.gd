extends Node2D


@onready var map: Sprite2D = $MapSprite2D
@onready var camera: Camera2D = $Camera2D

@onready var down_border: CollisionShape2D = $Borders/DownBorder
@onready var right_border: CollisionShape2D = $Borders/RightBorder

@export var food_counter: Resource
@export var big_food_scene: PackedScene
@export var small_food_scene: PackedScene

@onready var snake_container: Node2D = $SnakeContainer

@onready var leaderboard: Node2D = $Leaderboard

@onready var selection_agents: Timer = $SelectionComponent
@export var select_n_bests: int = 5

@export var agent_scene: PackedScene
@export var player_scene: PackedScene


func _ready() -> void:
	down_border.position = Vector2.DOWN * map.CELL_SIZE * map.height
	right_border.position = Vector2.RIGHT * map.CELL_SIZE * map.width

	food_counter.setMaxFoodMass(map.width * map.height / 2)
	spawn_small_food()

	for i in range(10):
		spawn_agent()
	# spawn_player()

	selection_agents.timeout.connect(_on_selection_agents_timeout)

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
	snake.snake_exit.connect(_on_snake_exit)
	snake.snake_died.connect(_on_snake_died)
	snake_container.add_child(snake)
	if snake is Agent:
		leaderboard.add_agent(snake)

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
		leaderboard.remove_agent(snake)

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

func _on_selection_agents_timeout() -> void:
	print("test")
	if select_n_bests > leaderboard.agent_array.size():
		push_error("Selecting more agents than there are existing is forbidden")
		return
	for i in range(leaderboard.agent_array.size() - 1, -1, -1):
		if i >= select_n_bests:
			leaderboard.agent_array[i].die()
		else:
			var new_agent = agent_scene.instantiate()
			spawn_snake(new_agent)
			var parent_agent = leaderboard.agent_array[i]
			new_agent.head.brain = parent_agent.head.brain.duplicate()
			new_agent.head.brain.mutate()
