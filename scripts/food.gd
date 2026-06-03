class_name Food
extends Area2D


var mass: int = 1
var size: float = 1.0


func _ready() -> void:
	scale = Vector2.ONE * size
