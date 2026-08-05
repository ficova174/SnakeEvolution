extends Node2D


@export_group("Ressources")
@export var head_texture: Texture2D = preload("res://assets/head.png")
@export var body_texture: Texture2D = preload("res://assets/body.png")

@export_group("Simulation parameters")
@export var population_size: int = 200
@export var initial_body_segments: int = 4
@export var segment_spacing: float = 20.0
@export var head_radius: float = 32.0


class BodySegment:
	var mass: int = 10
	var pos: Vector2
	var moving: bool = false # used when spawning a snake to avoid spring like effect

	var body_sprite: Sprite2D
	var segment_area_rid: RID
	var segment_shape_rid: RID

class Agent:
	var is_alive: bool = true
	var head_pos: Vector2
	var direction: Vector2
	var acceleration: float = 300.0 # px/s^2
	var speed: float = 400.0
	var min_speed: float = 300.0 # px/s
	var max_speed: float = 600.0 # px/s
	var rotation_speed: float = 6.0 # rad/s

	var head_body_rid: RID
	var head_shape_rid: RID

	var head_sprite: Sprite2D

	var body_segments: Array[BodySegment]

@onready var map: Sprite2D = $MapSprite2D
var space_rid: RID
var agents: Array[Agent]


func _ready() -> void:
	space_rid = get_world_2d().space
	spawn_population()

func spawn_population() -> void:
	while agents.size() < population_size:
		var agent:Agent = Agent.new()
		agent.head_pos = Vector2(
			randf_range(map.CELL_SIZE, (map.width - 1) * map.CELL_SIZE),
			randf_range(map.CELL_SIZE, (map.height - 1) * map.CELL_SIZE)
		)
		agent.direction = Vector2.RIGHT.rotated(randf() * TAU)

		agent.head_shape_rid = PhysicsServer2D.circle_shape_create()
		PhysicsServer2D.shape_set_data(agent.head_shape_rid, head_radius)
	
		agent.head_sprite = Sprite2D.new()
		agent.head_sprite.texture = head_texture
		add_child(agent.head_sprite)

		agent.head_body_rid = PhysicsServer2D.body_create()
		PhysicsServer2D.body_set_space(agent.head_body_rid, space_rid)
		PhysicsServer2D.body_add_shape(agent.head_body_rid, agent.head_shape_rid)
		PhysicsServer2D.body_set_mode(agent.head_body_rid, PhysicsServer2D.BODY_MODE_KINEMATIC)

		spawn_body_segments(agent)

		agents.append(agent)

func spawn_body_segments(agent: Agent) -> void:
	for j in range(initial_body_segments):
		var body_segment: BodySegment = BodySegment.new()

		body_segment.body_sprite = Sprite2D.new()
		body_segment.body_sprite.texture = body_texture
		add_child(body_segment.body_sprite)

		body_segment.segment_area_rid = PhysicsServer2D.area_create()
		PhysicsServer2D.area_set_space(body_segment.segment_area_rid, space_rid)
		PhysicsServer2D.area_add_shape(body_segment.segment_area_rid, body_segment.segment_shape_rid)

		var layer_3_mask = 1 << (3 - 1)
		var layer_0_mask = 0
		PhysicsServer2D.area_set_collision_layer(body_segment.segment_area_rid, layer_3_mask)
		PhysicsServer2D.area_set_collision_mask(body_segment.segment_area_rid, layer_0_mask)

		body_segment.pos = agent.head_pos
		agent.body_segments.append(agent.head_pos)

func _physics_process(_delta: float) -> void:
	pass

func _exit_tree() -> void:
	for agent in agents:
		for segment in agent.body_segments:
			PhysicsServer2D.free_rid(segment.segment_area_rid)
			PhysicsServer2D.free_rid(agent.segment_shape_rid)
		PhysicsServer2D.free_rid(agent.head_body_rid)
		PhysicsServer2D.free_rid(agent.head_shape_rid)
