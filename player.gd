extends CharacterBody2D


@export var genome: Genome
@export var mass: int = 10
var speed: float
var current_acc_duration: float = 0.0


func _ready() -> void:
	var head = get_node("Head")
	var mouth = get_node("Mouth")
	mouth.

func set_genome(genome_init: Genome) -> void:
	genome = genome_init
	speed = genome.speed

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("dash") and current_acc_duration <= genome.full_acc_duration:
		speed += genome.acceleration * delta
		current_acc_duration += delta
	elif not Input.is_action_pressed("dash") and current_acc_duration > genome.full_acc_duration:
		speed -= genome.acceleration * delta
		current_acc_duration -= delta
	velocity = transform.x * speed
	move_and_slide()
