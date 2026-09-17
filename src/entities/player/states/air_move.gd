extends State


@export var player: Player
@export var speed: float = 10
@export var accel: float = 2
@export var deccel: float = 1
@export var air_strafe_curve: Curve

@onready var ground_move: State = %GroundMove
@onready var debug_wish_angle: Label = $"../../CanvasLayer/Control/VBoxContainer/DebugWishAngle"
@onready var wallrun: State = $"../Wallrun"
@onready var wall_raycasts: WallRaycasts = $"../../WallRaycasts"


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if wall_raycasts.is_colliding():
		if player.highest_run == -9999:
			state_machine.change_state(wallrun)
		if player.global_position.y < player.highest_run:
			state_machine.change_state(wallrun)
	
	
	var horizontal_vec := Vector2(player.velocity.x, player.velocity.z)
	var horizontal_wish := Vector2(player.wish_vel.x, player.wish_vel.z)
	var diff := rad_to_deg(horizontal_vec.angle_to(horizontal_wish))
	var air_strafe_mult := air_strafe_curve.sample(abs(diff))
	
	$"../../CanvasLayer/Control/VBoxContainer/Velocity".text = "vel" + str(player.velocity)
	$"../../CanvasLayer/Control/VBoxContainer/WishVelocity".text = "wishVel" + str(player.wish_vel)
	$"../../CanvasLayer/Control/VBoxContainer/AirStrafeMult".text = "mult" + str(air_strafe_mult)
	
	
	debug_wish_angle.text = "diff: " + str(diff)
	player.velocity += player.get_gravity() * 5 * delta
	
	if player.is_on_floor():
		state_machine.change_state(ground_move)
	
	player.wish_vel = player.direction * (speed * air_strafe_mult)
	
	if player.direction.length() > 0:
		player.velocity.x = player.wish_vel.x + (player.velocity.x - player.wish_vel.x) * exp(-accel * delta)
		player.velocity.z = player.wish_vel.z + (player.velocity.z - player.wish_vel.z) * exp(-accel * delta)
	else:
		player.velocity.x = 0 + (player.velocity.x - 0) * exp(-deccel * delta)
		player.velocity.z = 0 + (player.velocity.z - 0) * exp(-deccel * delta)


func handle_input(_event: InputEvent) -> void:
	pass
