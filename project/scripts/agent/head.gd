extends Head


@onready var camera: Camera2D = $Camera2D
@onready var vision: Node2D = $VisionComponent
@export var brain: Resource


func _ready() -> void:
	brain.first_initialize([vision.number_rays * vision.nb_info_raycast, 30, 30, 2])

func _physics_process(delta: float) -> void:
	var inputs: PackedFloat32Array = vision.get_inputs()
	var outputs: PackedFloat32Array = brain.feedforward(inputs)

	var dashed: bool = true if outputs[0] >= 0.5 else false
	var rotation_amount: float = (outputs[1] * 2.0) - 1.0 # turn sigmoid to tanh

	if dashed:
		speed = move_toward(speed, genome.max_speed, genome.acceleration * delta)
	else:
		speed = move_toward(speed, genome.min_speed, genome.acceleration * delta)

	rotation += rotation_amount * genome.rotation_speed * delta

	super(delta)

	queue_redraw()

func _draw() -> void:
	if not camera.is_current():
		vision.visible = false
		return
	vision.visible = true
	vision.queue_redraw()
