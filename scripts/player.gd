class_name Player
extends Node2D


@export var genome: Genome
@export var segment_scene: PackedScene

@export var mass: float = 10.0
var speed: float
@export var rotation_speed: float
var body_segments: Array[BodySegment]
@export var segment_distance: float = 20.0

@onready var head: CharacterBody2D = $Head
@onready var mouth: Area2D = $Head/Mouth
@onready var body_container: Node2D = $BodyContainer


func _ready() -> void:
	head.min_speed = genome.min_speed
	head.max_speed = genome.max_speed
	head.acceleration = genome.acceleration

	mouth.area_entered.connect(_on_mouth_area_entered)
	mouth.body_entered.connect(_on_mouth_body_entered)

	var body_segment: BodySegment = segment_scene.instantiate()
	body_segment.position = head.position
	body_container.add_child(body_segment)
	body_segments.append(body_segment)
	grow()

func _on_mouth_area_entered(area: Area2D) -> void:
	if area is Food:
		var food: Food = area
		mass += food.mass
		food.queue_free()
		call_deferred("grow")

func grow() -> void:
	if body_segments.size() > mass:
		push_error("More body segments than mass")
	else:
		while body_segments.size() < mass:
			var body_segment: BodySegment = segment_scene.instantiate()
			body_segment.position = body_segments[-1].position
			body_container.add_child(body_segment)
			body_segments.append(body_segment)

func _on_mouth_body_entered(node: Node2D) -> void:
	if node is Player and node != self:
		die()

func die() -> void:
	print("dead")

func _physics_process(_delta: float) -> void:
	var body_to_head: Vector2 = body_segments[0].position.direction_to(head.position)
	var distance: float = body_segments[0].position.distance_to(head.position)
	if distance != segment_distance:
		body_segments[0].position += (distance - segment_distance) * body_to_head

	for i in range(1, body_segments.size()):
		var front: BodySegment = body_segments[i-1]
		var back: BodySegment = body_segments[i]
		var back_to_front: Vector2 = back.position.direction_to(front.position)
		distance = back.position.distance_to(front.position)

		if not back.moving and distance < segment_distance:
			continue
		elif not back.moving and distance >= segment_distance:
			back.moving = true

		if distance != segment_distance:
			back.position += (distance - segment_distance) * back_to_front
