extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = 650
@export var gravity: float = 1000.0

@export var attack_cooldown: float = 0.5  # seconds between attacks
var can_attack = true
var health = 10
@onready var hitbox = $AnimatedSprite2D/Area2D

@onready var healthBar = $healthBar
@onready var sprite = $AnimatedSprite2D

func _ready():
	hitbox.monitoring = false
func _physics_process(delta):
	if Input.is_action_just_pressed("rattack") and can_attack:
		attack()
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	direction = direction.normalized()

	velocity.y += gravity * delta

	if Input.is_action_just_pressed("rjump") and is_on_floor():
		velocity.y = -jump_force

	velocity.x = direction.x * speed
	if not is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")  # Going up
		else:
			$AnimatedSprite2D.play("fall")  # Falling down (if you have a "fall" anim)
	elif velocity.x != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("default")
	move_and_slide()
	
	healthBar.value = health

	if direction.x != 0:
		sprite.flip_h = direction.x < 0
	if direction.x < 0:
		$AnimatedSprite2D/Area2D.scale.x = -1
	elif direction.x > 0:
		$AnimatedSprite2D/Area2D.scale.x = 1


func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()




func attack():
	can_attack = false
	hitbox.monitoring = true
	await get_tree().create_timer(0.1).timeout
	hitbox.monitoring = false

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


func _on_area_2d_body_entered(body):
	if hitbox.monitoring and body.name == "player1":
		body.take_damage(1)
