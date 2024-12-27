extends CharacterBody2D

signal player_has_finally_hit_the_peach

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var screensize = get_viewport_rect().size
@export var spawns: PackedScene = preload("res://scenes/frozen/enemies/peach.tscn")

const GRAVITY = 300
const MAX_DIVISION_LEVEL = 4

var direction = Vector2.ZERO
var division_level: int = 0
var speed: int = 100
var jump_height: int = 800
var has_hit_the_peach_yet: bool = false

func _ready() -> void:
	velocity.x = speed * direction.x
	velocity.y = jump_height

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		var jump_force = sqrt(2.0 * jump_height * GRAVITY)
		velocity += Vector2(0, jump_force * delta)
	animation_player.play("shoot")
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var bounce_velocity = velocity.bounce(collision.get_normal())
		velocity.x = bounce_velocity.x
		velocity.y = -abs(velocity.y)

func died() -> void:
	if not has_hit_the_peach_yet:
		has_hit_the_peach_yet = true
		player_has_finally_hit_the_peach.emit()
	
	Manager.add_point()
	if division_level < MAX_DIVISION_LEVEL:
		spawn_smaller_selves.call_deferred()
	queue_free()

func spawn_smaller_selves() -> void:
	var num_peach: int = 2
	var spawn_directions = [
		Vector2(-1, -1).normalized(),  # Upper left
		Vector2(1, -1).normalized()   # Upper right
	]
	
	var spawn_positions = [
		Vector2(position.x, position.y - 20.0),
		Vector2(position.x, position.y + 20.0),
	]
	
	for i in range(num_peach):
		var new_peach = spawns.instantiate()
		new_peach.position = spawn_positions[i]
		new_peach.division_level = division_level + 1
		new_peach.speed = speed * 1.2
		new_peach.direction = spawn_directions[i]
		get_parent().add_child(new_peach)
