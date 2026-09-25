extends State

@export var player: Player


func enter() -> void:
	# figure out which general direction the player is looking at the wall
	# then set a variable
	# dot product probably
	# after that
	# if the player is pressing w or spacebar
	# increase the height of the player depending on their angle
	# otherwise, simply slow down their y velocity while they're on a waqll
	# and the drag here slowly lessens until they don't have enough "grip" on the wall
	# that they transition back into air move
	# note that they cannot go back to wallmove
	# until they either hit the floor
	# or wall jump, in which case they can go wall move again
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass
