extends CharacterBody2D

signal has_finally_pressed_space

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Marker2D
@export var BulletScene: PackedScene = preload("res://scenes/frozen/bullet.tscn")
var has_pressed_space_yet: bool = false

const SPEED = 130.0

func can_shoot() -> bool:
	return true

func shoot() -> void:
	var bullet = BulletScene.instantiate()
	owner.add_child(bullet)
	bullet.transform = muzzle.global_transform

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_shoot():
		if not has_pressed_space_yet:
			has_pressed_space_yet = true
			has_finally_pressed_space.emit()
		shoot()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("default")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jumping")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
