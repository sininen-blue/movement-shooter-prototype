extends State


@export var player: Player
@export var speed: float = 10
@export var accel: float = 5
@export var deccel: float = 8


@onready var air_move: State = %AirMove
@onready var slide: State = %Slide


func _ready() -> void:
	if player:
		player.player_jumped.connect(_on_player_jumped)
		player.player_crouched.connect(_on_player_crouched)


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if player.is_on_floor() == false:
		state_machine.change_state(air_move)
	
	player.wish_vel = player.direction * speed
	
	if player.direction.length() > 0:
		player.velocity = Utils.exp_decay(player.velocity, player.wish_vel, accel, delta)
	else:
		player.velocity = Utils.exp_decay(player.velocity, player.direction, deccel, delta)


func _on_player_jumped() -> void:
	state_machine.change_state(air_move)


func _on_player_crouched() -> void:
	pass
