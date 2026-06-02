extends Node2D


func _ready() -> void:
	var genome = Genome.new()
	spawn_snake(genome)
	var food = preload("res://food.tscn").instantiate()
	add_child(food)

func spawn_snake(genome: Genome) -> void:
	var snake = preload("res://player.tscn").instantiate()
	snake.set_genome(genome)
	snake.position = Vector2.ONE * 100.0
	add_child(snake)
