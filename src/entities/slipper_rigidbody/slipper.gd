extends RigidBody3D


@export var direction: Vector3
@export var initial_force: float = 25
@export var velocity_force: float = 0

var has_hit_wall: bool = false:
	set = _set_has_hit_wall

func _ready() -> void:
	self.physics_material_override = PhysicsMaterial.new()
	self.physics_material_override.set_bounce(0.8)
	if direction:
		apply_central_impulse(direction * (initial_force + velocity_force))


func _physics_process(_delta: float) -> void:
	if self.get_contact_count() > 0:
		self.has_hit_wall = true
	

func _set_has_hit_wall(new_val: bool) -> void:
	has_hit_wall = new_val
	
	if has_hit_wall:
		self.physics_material_override.set_bounce(0.2)
		self.gravity_scale = 1
