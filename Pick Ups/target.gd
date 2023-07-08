extends Node2D

var collected = false

func _ready():
	deactivate()
	
func activate():
	collected = false
	visible = true

func deactivate():
	visible = false
	
func _on_pick_up_body_entered(body):
	collected = true
	deactivate()
