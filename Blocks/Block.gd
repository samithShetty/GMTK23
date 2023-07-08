class_name Block
extends RigidBody2D

@export var cost: int = 50
@onready var parentBlock = get_parent()
@onready var game_controller = parentBlock.get_parent()

signal block_placed(name:StringName, position: Vector2)
signal block_moved(name:StringName)

# Called when the node enters the scene tree for the first time.
func _ready():
	block_placed.connect(Callable(game_controller,"check_block"))
	block_moved.connect(Callable(game_controller,"remove_block"))

func explode(): # Hit directly with dynamite
	emit_signal("block_moved", parentBlock.name)
	parentBlock.queue_free() 
	
func _on_sleeping_state_changed(): 
	if(sleeping): # Block has come to rest
		emit_signal("block_placed", parentBlock.name, global_position)
	else: # Stationary block was moved/destroyed
		emit_signal("block_moved", parentBlock.name)
