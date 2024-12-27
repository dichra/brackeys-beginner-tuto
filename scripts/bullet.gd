class_name Bullet extends Area2D

var speed: int = 100

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.is_in_group("mobs"):
		body.died()


func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	queue_free()
