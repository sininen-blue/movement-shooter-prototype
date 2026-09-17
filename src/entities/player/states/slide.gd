extends State

@export var player: Player
@export var slide_boost: float = 10
@export var slide_boost_cooldown: float = 2
@export var slide_drag: float = 2
@export var slide_drag_curve: Curve
@export var inclide_drag_curve: Curve


var time: float = 0
var speed: float = 0
var current_drag: float = 0
var current_floor_weight: float = 0
var floor_normal: Vector3 = Vector3()

@onready var air_move: State = %AirMove
@onready var ground_move: State = %GroundMove
@onready var head: Marker3D = $"../../Head"


func enter() -> void:
	head.position.y = 0.25
	time = 0
	player.velocity += player.velocity.normalized() * slide_boost
	speed = player.velocity.length()


func exit() -> void:
	head.position.y = 1.25


func update(delta: float) -> void:
	time += 1 * delta
	
	if player.is_on_floor():
		if player.get_last_motion().y > 0:
			print("going up")
			current_floor_weight = 0
		elif player.get_last_motion().y <= 0 and player.get_floor_angle() != 0:
			speed += 100 * delta
			print("going down")
		else:
			current_floor_weight = player.get_floor_angle() / player.floor_max_angle


func physics_update(delta: float) -> void:
	if player.get_floor_normal():
		floor_normal = player.get_floor_normal()
	
	player.velocity += player.get_gravity() * 5 * delta
	
	player.wish_vel = player.direction * speed
	var floor_normal := player.get_floor_normal()
	player.wish_vel = player.wish_vel.slide(floor_normal)
	speed = 0 + (speed - 0) * exp(-current_drag * delta)

	current_drag = (slide_drag_curve.sample(time) * slide_drag) * inclide_drag_curve.sample(current_floor_weight)
	player.velocity.x = player.wish_vel.x + (player.velocity.x - player.wish_vel.x) * exp(-10 * delta)
	player.velocity.z = player.wish_vel.z + (player.velocity.z - player.wish_vel.z) * exp(-10 * delta)
	
	if player.velocity.length() < 5:
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
