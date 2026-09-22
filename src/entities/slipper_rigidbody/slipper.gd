extends RigidBody3D


@export var direction: Vector3


func _ready() -> void:
	if direction:
		apply_central_impulse(direction * 50)
