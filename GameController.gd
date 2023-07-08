class_name GameController
extends Node2D

@export var player: Node
@onready var timer = $Timer
@onready var target = $Target

var money: int = 0
var score : int = 0

@export var timer_length := 5
var goal_height: float = 0.
var current_high_point := Vector2.ZERO
var best_height: float = 0.
var block_positions: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(timer_length)

func _on_timer_timeout():
	if player.buildMode: #Construction Mode
		if -current_high_point.y < goal_height: # Lose Condition
			end_game()
		else:
			target.position = current_high_point + Vector2.UP*30
			target.activate()
			
	else: # Demolition Mode
		if player.money < 0 or not target.collected: # Lose Condition
			end_game() # Player should explode?
		else:
			goal_height = 10
	
	player.change_mode()
	timer.start(timer_length)

func end_game():
	print("YOU LOSE")

func check_block(block_name:StringName, block_position: Vector2):
	block_positions[block_name] = block_position
	print(current_high_point)
	if block_position.y < current_high_point.y: # Both are negative, > gets reversed
		current_high_point = block_position
			
func remove_block(block_name):
	if not block_positions.has(block_name):
		return
		
	var block_position = block_positions[block_name]
	block_positions.erase(block_name)
	if (block_position == current_high_point): # Current highest block has been moved/destroyed, find next tallest
		var leftover_positions = block_positions.values()
		leftover_positions.sort_custom(func(a,b): return -a.y > -b.y)
		current_high_point =  leftover_positions[0] if block_positions.size() > 0 else Vector2.ZERO 
		print(current_high_point)
