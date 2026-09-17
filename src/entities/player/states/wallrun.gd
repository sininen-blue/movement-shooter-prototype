extends State

@export var player: Player
@export var wall_run_curve: Curve
@export var speed = 40
@export var accel = 2
@export var max_duration = 1.75

var time = 0
var wall_normal
var wall_x
var player_direction
var wall_dir

# TODO: need minimum distance from floor

@onready var air_move: State = %AirMove
@onready var ground_move: State = %GroundMove


func enter() -> void:
	if player.global_position.y > player.highest_run:
		player.highest_run = player.global_position.y
	
	
	time = 0
	wall_x = Vector3(wall_normal.x, 0, wall_normal.z).normalized()
	var vel_x: Vector3 = Vector3(player.velocity.x, 0, player.velocity.z).normalized()
	
	var v_along_normal: Vector3 = vel_x.dot(wall_x) * wall_x
	var v_tangent: Vector3 = player.velocity - v_along_normal
	player_direction = v_tangent.normalized()


func exit() -> void:
	pass

## TODO: cooldown on each direction cast
func update(delta: float) -> void:
	time += 1 * delta
	
	if time > max_duration:
		state_machine.change_state(air_move)


func physics_update(delta: float) -> void:
	player.velocity.y = wall_run_curve.sample(time) * 10
	
	player.velocity += -wall_x * 2
	
	player.wish_vel = player_direction * speed
	
	player.velocity.x = player.wish_vel.x + (player.velocity.x - player.wish_vel.x) * exp(-accel * delta)
	player.velocity.z = player.wish_vel.z + (player.velocity.z - player.wish_vel.z) * exp(-accel * delta)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump"):
		player.velocity += (wall_normal * 30) + Vector3(0, 10, 0)
		state_machine.change_state(air_move)
