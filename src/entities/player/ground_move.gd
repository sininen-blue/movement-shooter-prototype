extends State


@export var player: Player
@export var speed: float = 10
@export var accel: float = 5
@export var deccel: float = 8


@onready var air_move: State = %AirMove
@onready var slide: State = %Slide


func enter() -> void:
	player.highest_run = -9999


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if player.is_on_floor() == false:
		state_machine.change_state(air_move)
	
	player.wish_vel = player.direction * speed
	
	if player.direction.length() > 0:
		player.velocity = player.wish_vel + (player.velocity - player.wish_vel) * exp(-accel * delta)
	else:
		player.velocity = Vector3.ZERO + (player.velocity - Vector3.ZERO) * exp(-deccel * delta)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_jump"):
		player.velocity.y += 20
	
	if event.is_action_pressed("slide"):
		state_machine.change_state(slide)
