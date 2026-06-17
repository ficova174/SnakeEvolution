class_name Head
extends CharacterBody2D


signal die

var genome: Genome
var speed: float


func initialize(genome_init: Genome):
	genome = genome_init
	speed = genome.min_speed

func _physics_process(delta: float) -> void:
	var motion: Vector2 = Vector2.RIGHT.rotated(rotation) * speed * delta
	if move_and_collide(motion) != null: # wall collisions thanks to collision mask
		die.emit()
