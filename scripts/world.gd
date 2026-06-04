extends Node2D


@onready var down_border = $Borders/DownBorder
@onready var right_border = $Borders/RightBorder

@onready var map = $MapSprite2D


func _ready() -> void:
	down_border.position = Vector2.DOWN * map.CELL_SIZE * map.height
	right_border.position = Vector2.RIGHT * map.CELL_SIZE * map.width
