class_name Player
extends Node2D


@export var genome: Genome
@export var segment_scene: PackedScene

@export var mass: float = 10.0
var speed: float
var rotation_speed: float
var body_segments: Array[BodySegment]

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
