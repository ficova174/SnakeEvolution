class_name Player
extends Node2D

signal enter_snake
signal exit_snake
signal snake_died

@export var genome: Genome
@export var segment_scene: PackedScene

@export var mass: int = 10
var speed: float
@export var rotation_speed: float
@export var segment_distance: float = 20.0
var body_segments: Array[BodySegment]

@onready var head: CharacterBody2D = $Head
@onready var mouth: Area2D = $Head/Mouth
@onready var camera: Camera2D = $Head/Camera2D
@onready var body_container: Node2D = $BodyContainer


func _ready() -> void:
	head.min_speed = genome.min_speed
	head.max_speed = genome.max_speed
	head.acceleration = genome.acceleration

	mouth.area_entered.connect(_on_mouth_area_entered)
	mouth.body_entered.connect(_on_mouth_body_entered)

	var body_segment: BodySegment = segment_scene.instantiate()
	body_segment.input_event.connect(_on_body_clicked)
	body_segment.position = head.position
	body_container.add_child(body_segment)
	body_segments.append(body_segment)
	grow()

	head.input_event.connect(_on_head_clicked)

func _on_mouth_area_entered(area: Area2D) -> void:
	if area is Food:
		var food: Food = area
		mass += food.mass
		food.queue_free()
		call_deferred("grow")
	elif area is BodySegment:
		if not area in body_segments:
			die()

func _on_mouth_body_entered(body: CharacterBody2D) -> void:
	if body is Head:
		if body != head:
			die()

func grow() -> void:
	var segment_mass: int = body_segments[0].mass
	var target_mass: int = mass
	var actual_mass: int = body_segments.size() * segment_mass

	if actual_mass > target_mass:
		print("Target mass : ", target_mass)
		print("Actual mass : ", actual_mass)
		push_error("More body segments than expected")
		return

	while actual_mass + segment_mass < target_mass:
		var new_segment: BodySegment = segment_scene.instantiate()
		new_segment.input_event.connect(_on_body_clicked)
		new_segment.position = body_segments[-1].position
		body_container.add_child(new_segment)
		body_segments.append(new_segment)
		actual_mass += segment_mass

func die() -> void:
	snake_died.emit()
	queue_free()

func _on_head_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	switch_camera(event)

func _on_body_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	switch_camera(event)

func switch_camera(event: InputEvent) -> void:
	if event.is_action_pressed("enter_snake"):
		camera.enabled = true
		enter_snake.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_snake"):
		camera.enabled = false
		exit_snake.emit()

func _physics_process(_delta: float) -> void:
	var body_to_head: Vector2 = body_segments[0].position.direction_to(head.position)
	var distance: float = body_segments[0].position.distance_to(head.position)
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

		back.position += (distance - segment_distance) * back_to_front
