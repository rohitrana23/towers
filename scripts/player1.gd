extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = 650
@export var gravity: float = 1000.0


@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	direction = direction.normalized()

	velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force

	velocity.x = direction.x * speed

	move_and_slide()

	if direction.x != 0:
		sprite.flip_h = direction.x < 0
