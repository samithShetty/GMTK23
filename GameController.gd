extends Node2D

@export var player: Node
@onready var timer = $Timer

var money: int = 0
var score : int = 0

@export var timer_length := 5
var goal_height: float = 0.
var current_height: float = 0.
var best_height: float = 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(timer_length)


func _on_timer_timeout():
	if player.buildMode: #Construction Mode
		if current_height < goal_height: # Lose Condition
			end_game()
	else: # Demolition Mode
		if player.money < 0: # Lose Condition
			end_game() # Player should explode?
		else:
			goal_height = 10
			
	player.change_mode()
	timer.start(timer_length)


func end_game():
	print("YOU LOSE")

func check_block(height: float):
	if height > current_height:
		current_height = height
