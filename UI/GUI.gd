extends Control

@export var game_controller: Node2D
@export var player: Node2D

@onready var timer_label = $Timer
@onready var money_label = $Money

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_gui_timer()
	update_gui_money()

func update_gui_timer():
	if game_controller.timer.time_left > 10:
		timer_label.text = "%.f" % game_controller.timer.time_left
	else:
		timer_label.text = "%.1f" % game_controller.timer.time_left

func update_gui_money():
	if player.money >= 0:
		money_label.text = "$%s" % player.money
	else:
		money_label.text = "-$%s" % -player.money
