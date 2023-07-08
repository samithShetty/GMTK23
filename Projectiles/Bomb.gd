class_name Bomb
extends Node2D

signal demolition(block:Block)

@export var explosion_force = 200
@onready var explosion = $Block/ShapeCast2D


func explode():
	explosion.force_shapecast_update()
	for collision in explosion.collision_result:
		if collision.collider is RigidBody2D: # Boxes
			collision.collider.apply_impulse(-collision.normal*explosion_force, position)
		else: # Player 
			# blast player up and in the direction they are moving 
			collision.collider.velocity.x *= 2
			collision.collider.velocity.y -= explosion_force
			

	queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("detonate"):
		explode()


func _on_collision(body):
	if body is RigidBody2D:
		emit_signal("demolition",body)
		body.explode()
	explode()
