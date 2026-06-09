extends Sprite2D


const CELL_SIZE: int = 58
@export var width: int = 10
@export var height: int = 10


func _ready() -> void:
	region_rect = Rect2(0, 0, width * CELL_SIZE, height * CELL_SIZE)
