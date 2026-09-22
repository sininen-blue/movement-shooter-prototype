extends State

@export var player: Player
@export var wall_run_curve: Curve
@export var jump = 30
@export var speed = 40
@export var accel = 2
@export var duration = 1.75


var left_wall_normal: Vector3
var right_wall_normal: Vector3
var start_vel: Vector3
var new_dir: Vector3
var time: float = 0

@onready var air_move: State = %AirMove
@onready var ground_move: State = %GroundMove


func _ready() -> void:
	player.player_wall_jumped.connect(_on_player_wall_jumped)


func enter() -> void:
	player.can_wall_jump = true

	start_vel = player.velocity

	if player.left_wall and player.can_wallrun_left:
		player.can_wallrun_right = true
		player.can_wallrun_left = false

	if player.right_wall and player.can_wallrun_right:
		player.can_wallrun_right = false
		player.can_wallrun_left = true


func exit() -> void:
	player.can_wall_jump = false

	time = 0


func update(delta: float) -> void:
	time += 1 * delta
	
	if time > duration:
		state_machine.change_state(air_move)


func physics_update(delta: float) -> void:
	left_wall_normal = player.get_wall_normal().rotated(Vector3.UP, PI/2)
	right_wall_normal = player.get_wall_normal().rotated(Vector3.UP, -PI/2)

	if left_wall_normal.angle_to(start_vel) < right_wall_normal.angle_to(start_vel):
		new_dir = left_wall_normal
	else:
		new_dir = right_wall_normal
	
	if new_dir:
		player.velocity = new_dir.normalized() * clamp(start_vel.length(), speed/2.0, speed * 2)
	player.velocity -= player.get_wall_normal() * 2

	if time <= duration and player.is_on_wall_only():
		time += 1 * delta
	else:
		state_machine.change_state(air_move)


func _on_player_wall_jumped() -> void:
	player.velocity += (Vector3.UP + player.get_wall_normal()/2).normalized() * jump
