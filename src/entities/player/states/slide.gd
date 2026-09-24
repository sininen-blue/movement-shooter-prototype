extends State

@export var player: Player
@export var max_slide_speed: float = 200
@export var accel: float = 5 # turn speed
@export var slide_speed: float = 4 # constant speed boost on slide down

@export var slide_boost: float = 10
@export var slide_boost_cooldown: float = 2
@export var slide_drag: float = 2
@export var slide_drag_curve: Curve
@export var inclide_drag_curve: Curve


var time: float = 0
var time_sample_point: float = 0

var angle: float = 0
var angle_sample_point: float = 0

var angle_drag_weight: float = 0

var current_drag: float = 0
var current_floor_weight: float = 0
var floor_normal: Vector3 = Vector3()

var is_going_down: bool = false

@onready var air_move: State = %AirMove
@onready var ground_move: State = %GroundMove
@onready var head: Marker3D = $"../../Head"


func _ready() -> void:
	player.player_uncrouched.connect(_on_player_uncrouched)


func enter() -> void:
	head.position.y = 0.25
	time = 0
	# TODO: needs cooldown
	player.velocity += player.velocity.normalized() * slide_boost


func exit() -> void:
	head.position.y = 1.25


func update(delta: float) -> void:
	time += 1 * delta


func physics_update(delta: float) -> void:
	player.velocity += player.get_gravity() * player.mass * delta

	is_going_down = player.velocity.dot(player.get_floor_normal()) > 0
	if is_going_down and player.velocity.length() < max_slide_speed:
		player.velocity += player.velocity.normalized() * delta * slide_speed
	
	if is_going_down:
		angle_sample_point = player.get_floor_angle() / player.floor_max_angle
	else:
		angle_sample_point = 0.0

	angle_drag_weight = inclide_drag_curve.sample(angle_sample_point)

	current_drag = slide_drag_curve.sample(time) * angle_drag_weight
	player.wish_vel = player.direction

	var new_velocity_len = Utils.exp_decay(player.velocity, Vector3.ZERO, current_drag, delta).length()
	var slided_wish_vel = player.wish_vel.slide(player.get_floor_normal()).normalized()
	var new_vel_dir = Utils.exp_decay(player.velocity.normalized(), slided_wish_vel, accel, delta)

	player.velocity = new_vel_dir * new_velocity_len

	if player.velocity.length() < 5:
		if player.is_on_floor() == false:
			state_machine.change_state(air_move)
		else:
			state_machine.change_state(ground_move)

	if player.is_on_floor() == false:
		# TODO: add forgiveness
		state_machine.change_state(air_move)



func _on_player_uncrouched() -> void:
	if player.is_on_floor() == false:
		state_machine.change_state(air_move)
	else:
		state_machine.change_state(ground_move)


func handle_input(event: InputEvent) -> void:
	if event.is_action("move_jump"):
		player.velocity += (floor_normal * 20) 
		if player.is_on_floor() == false:
			state_machine.change_state(air_move)
		else:
			state_machine.change_state(ground_move)
