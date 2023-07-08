class_name Block
extends RigidBody2D

@export var cost: int = 50
@onready var game_controller = get_parent()
signal block_placed(height: float)

# Called when the node enters the scene tree for the first time.
func _ready():
	#block_placed.connect(game_controller.check_block)
	pass



func _on_sleeping_state_changed():
	if(sleeping): # Block has come to rest
		emit_signal("block_placed",position.y)
