extends Node2D


signal raycast_changed(colors: PackedColorArray)

var nb_info_raycast: int = 5
@export var number_rays: int = 100
@export var fov: float = 270.0

@onready var raycasts: Array[RayCast2D] = [$RayCast2D]

var dark_green: Color = Color(0.0, 0.148, 0.0, 1.0)
var light_green: Color = Color(0.0, 0.798, 0.0, 1.0)
var dark_orange: Color = Color(0.442, 0.154, 0.024, 1.0)
var light_orange: Color = Color(1.039, 0.552, 0.155, 1.0)
var dark_red: Color = Color(0.339, 0.0, 0.0, 1.0)
var light_red: Color = Color(1.086, 0.0, 0.0, 1.0)


func _ready() -> void:
	var raycast_template: RayCast2D = raycasts[0]
	var angle_step: float = fov / float(number_rays - 1)
	raycasts.clear() # to avoid duplicating the central ray
	for i in range(number_rays):
		var new_raycast: RayCast2D = raycast_template.duplicate()
		new_raycast.rotation_degrees = -(fov / 2.0) + i * angle_step
		self.add_child(new_raycast)
		raycasts.append(new_raycast)

func get_inputs() -> PackedFloat32Array:
	var inputs: PackedFloat32Array
	for raycast in raycasts:
		# collision?
		# distance?
		# Food?
		# Head?
		# Body?

		if not raycast.is_colliding():
			inputs.append(0.0)
			inputs.append(raycast.target_position.x)
			inputs.append(0.0)
			inputs.append(0.0)
			inputs.append(0.0)
			continue
		var collider: Object = raycast.get_collider()
		inputs.append(1.0)
		var target_position: Vector2 = to_local(raycast.get_collision_point())
		inputs.append(target_position.length())
		if collider is Food:
			inputs.append(1.0)
			inputs.append(0.0)
			inputs.append(0.0)
		elif collider is Head:
			inputs.append(0.0)
			inputs.append(1.0)
			inputs.append(0.0)
		elif collider is BodySegment:
			inputs.append(0.0)
			inputs.append(0.0)
			inputs.append(1.0)
	return inputs

func draw_raycasts() -> void:
	var colors: PackedColorArray
	var width: int = 2
	for raycast in raycasts:
		var rotated_target_position: Vector2 = raycast.target_position.rotated(raycast.rotation)
		if not raycast.is_colliding():
			draw_line(Vector2.ZERO, rotated_target_position, Color.WHITE, width)
			colors.append(Color.WHITE)
			continue
		var collider: Object = raycast.get_collider()
		var target_position: Vector2 = to_local(raycast.get_collision_point())
		var initial_actual_ratio: float = target_position.length() / rotated_target_position.length()
		initial_actual_ratio = clampf(initial_actual_ratio, 0.0, 1.0)
		if collider is Food:
			draw_line(Vector2.ZERO, target_position, Color.DARK_GREEN, width)
			colors.append(dark_green.lerp(light_green, initial_actual_ratio))
		elif collider is Head:
			draw_line(Vector2.ZERO, target_position, Color.DARK_ORANGE, width)
			colors.append(dark_orange.lerp(light_orange, initial_actual_ratio))
		elif collider is BodySegment:
			draw_line(Vector2.ZERO, target_position, Color.DARK_RED, width)
			colors.append(dark_red.lerp(light_red, initial_actual_ratio))

	raycast_changed.emit(colors)
