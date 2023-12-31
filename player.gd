extends CharacterBody2D

@export var game_controller : Node2D
@export var blocks : Array[PackedScene]
@export var dynamite : PackedScene

@onready var sprite = $AnimatedSprite2D

const MAX_VELOCITY = Vector2(800,800);
const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var buildMode := true
var item_index := 0
var money := 100 

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
		velocity.x = move_toward(velocity.x, 0, SPEED/7)
	if direction == 0.:
		sprite.play("construction_idle" if buildMode else "demolition_idle")
	else:
		sprite.play("construction_run" if buildMode else "demolition_run")
		if direction > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
			
	
	velocity = velocity.clamp(-MAX_VELOCITY, MAX_VELOCITY)
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("changeMode"):
		change_mode()
		
	elif event.is_action_pressed("select_item_1"):
		item_index = 0
	elif event.is_action_pressed("select_item_2"):
		item_index = 1
	elif event.is_action_pressed("select_item_3"):
		pass

func _input(event):
	if event.is_action_pressed("shoot"): 
		if buildMode: # Place Random Block 
			var block = blocks[item_index].instantiate()
			money -= block.get_child(0).cost		
			fireProjectile(block)
		else: # Throw Dynamite
			var bomb = dynamite.instantiate()
			bomb.demolition.connect(_block_destroyed)
			fireProjectile(bomb)

func fireProjectile(projectile: Node):
	var projVector = (get_global_mouse_position()-position) * 5
	projectile.position = position + projVector.normalized() * 30
	projectile.get_node("Block").apply_central_impulse(projVector);
	game_controller.add_child(projectile)
	
func change_mode():
		buildMode = !buildMode 
	
func _block_destroyed(block: Block):
	money += block.cost
