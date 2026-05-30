extends Sprite2D


var width: int = 10
var height: int = 10
var cell_size: int = 58


func _ready() -> void:
	region_rect = Rect2(0, 0, width * cell_size, height * cell_size)
