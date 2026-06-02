class_name Player
extends CharacterBody2D


@export var genome: Genome = Genome.new()
@export var mass: int = 10
var speed: float


func _ready() -> void:
	var mouth = get_node("Mouth")
	mouth.area_entered.connect(_on_mouth_area_entered)
	mouth.body_entered.connect(_on_mouth_body_entered)

func _on_mouth_area_entered(area: Area2D) -> void:
	if area is Food:
		var food: Food = area
		mass += food.mass
		food.queue_free()

func _on_mouth_body_entered(node: Node2D) -> void:
	if node is Player and node != self:
		die()

func set_genome(genome_init: Genome) -> void:
	genome = genome_init
	speed = genome.min_speed

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("dash"):
		speed = move_toward(speed, genome.max_speed, genome.acceleration * delta)
	else:
		speed = move_toward(speed, genome.min_speed, genome.acceleration * delta)
	velocity = transform.x * speed
	move_and_slide()

func die() -> void:
	pass
