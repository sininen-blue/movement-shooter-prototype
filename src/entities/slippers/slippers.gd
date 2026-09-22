extends CharacterBody3D


@export var direction: Vector3 = (Vector3.FORWARD/2 + Vector3.UP).normalized()
@export var initial_speed: float = 50
@export var accel: float = 15
@export var deccel: float = 1

@export var hit_slowdown: float = 20

var has_hit_wall: bool = false
var wish_vel: Vector3 = Vector3.ZERO
var speed = 0


func _ready() -> void:
	speed = initial_speed
	velocity = direction.normalized()


# convert to pure physics
func _physics_process(delta: float) -> void:
	if has_hit_wall:
		velocity.y += get_gravity().y * delta
	else:
		velocity.y += get_gravity().y/5 * delta

	speed = Utils.exp_decay(speed, 0, deccel, delta)

	wish_vel = velocity.normalized() * speed
	velocity = Utils.exp_decay(velocity, wish_vel, accel, delta)

	move_and_slide()

	if is_on_wall_only():
		if has_hit_wall:
			speed -= hit_slowdown
			speed = clampf(speed, 0, speed)

		has_hit_wall = true
		velocity = velocity.bounce(get_wall_normal())

	if is_on_floor():
		velocity = velocity.bounce(get_floor_normal())
