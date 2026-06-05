extends Node2D


@onready var down_border = $Borders/DownBorder
@onready var right_border = $Borders/RightBorder

@onready var map = $MapSprite2D
@onready var food_scene: PackedScene = preload("res://scenes/food.tscn")

var max_food: int = 100
var food_quantity: int = 0


func _ready() -> void:
	down_border.position = Vector2.DOWN * map.CELL_SIZE * map.height
	right_border.position = Vector2.RIGHT * map.CELL_SIZE * map.width

func _physics_process(_delta: float) -> void:
	if food_quantity < max_food:
		var food: Food = food_scene.instantiate()
		food.position[0] = randf_range(0.0, map.width * map.CELL_SIZE)
		food.position[1] = randf_range(0.0, map.height * map.CELL_SIZE)
		add_child(food)
		food_quantity += 1
