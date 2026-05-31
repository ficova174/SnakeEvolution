extends Sprite2D


const CELL_SIZE: int = 58
var width: int = 10
var height: int = 10


func _ready() -> void:
	region_rect = Rect2(0, 0, width * CELL_SIZE, height * CELL_SIZE)
