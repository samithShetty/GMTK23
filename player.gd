extends CharacterBody2D


@export var blocks : Array[PackedScene]
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var buildMode: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("action"): 
		if buildMode:# Place Random Block 
			fireProjectile(blocks.pick_random().instantiate())
		else:
			pass
			

func fireProjectile(projectile: Node):
	var projVector = (get_global_mouse_position()-position) * 5
	projectile.position = position + projVector.normalized() * 30
	projectile.get_node("Block").apply_central_impulse(projVector);
	add_sibling(projectile)
