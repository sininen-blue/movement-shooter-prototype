extends State


@export var player: Player
@export var speed: float = 10
@export var accel: float = 2
@export var deccel: float = 1
@export var air_strafe_curve: Curve
@export var min_strafe_angle: float = 0.0
@export var max_strafe_angle: float = 180.0
@export var air_strafe_mod: float = 1.0


var horizontal_vel: Vector2
var horizontal_wish: Vector2
var diff: float
var sample_point: float


@onready var ground_move: State = %GroundMove


func enter() -> void:
	if player.has_jumped:
		player.has_jumped = false


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if player.is_on_floor():
		state_machine.change_state(ground_move)

	player.velocity += player.get_gravity() * player.mass * delta
	player.wish_vel = player.direction * speed

	# air strafe
	horizontal_vel = Vector2(player.velocity.x, player.velocity.z)
	horizontal_wish = Vector2(player.wish_vel.x, player.wish_vel.z)
	diff = rad_to_deg(horizontal_vel.angle_to(horizontal_wish))
	sample_point = (diff - min_strafe_angle) / max_strafe_angle

	player.wish_vel *= 1.0 + (air_strafe_curve.sample(abs(sample_point)) * air_strafe_mod)
	
	if player.direction.length() > 0:
		player.velocity.x = Utils.exp_decay(player.velocity.x, player.wish_vel.x, accel, delta)
		player.velocity.z = Utils.exp_decay(player.velocity.z, player.wish_vel.z, accel, delta)
	else:
		player.velocity.x = Utils.exp_decay(player.velocity.x, player.direction.x, deccel, delta)
		player.velocity.z = Utils.exp_decay(player.velocity.z, player.wish_vel.z, accel, delta)
