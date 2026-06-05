class_name Head
extends CharacterBody2D


var acceleration: float
var speed: float
var min_speed: float
var max_speed: float


func _ready() -> void:
	speed = min_speed
