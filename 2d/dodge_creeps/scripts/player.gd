extends Area2D


signal hit

@export var speed := 400 # pixels/sec

var _screen_size: Vector2


func _ready() -> void:
	_screen_size = get_viewport_rect().size
	hide()


func initialize(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, _screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
