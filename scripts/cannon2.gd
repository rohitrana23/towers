extends CharacterBody2D

@export var cannonball_scene: PackedScene
@export var fire_cooldown: float = 1.0
@export var rotate_speed: float = 60.0  # degrees per second
var can_fire = true
var player_nearby = false
var rotating_up = true  # true = up, false = down
var is_paused = false   # Whether rotation is paused

@onready var bullet_spawn = $Marker2D
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	if player_nearby and not is_paused:
		# Rotate up or down between 0 and -90 degrees
		if rotating_up:
			rotation_degrees += rotate_speed * delta
			if rotation_degrees >= 90:
				rotation_degrees = 90
				rotating_up = false
		else:
			rotation_degrees -= rotate_speed * delta
			if rotation_degrees <= 0:
				rotation_degrees = 0
				rotating_up = true

	if player_nearby and Input.is_action_just_pressed("fire") and can_fire:
		is_paused = true  # Pause rotation immediately
		fire()

func fire():
	var cannonball = cannonball_scene.instantiate()
	cannonball.global_position = bullet_spawn.global_position
	cannonball.rotation = global_rotation
	cannonball.direction = Vector2.RIGHT.rotated(global_rotation)
	get_tree().current_scene.add_child(cannonball)

	can_fire = false
	await get_tree().create_timer(fire_cooldown).timeout
	can_fire = true
	is_paused = false  # Resume rotation after cooldown

func _on_area_2d_body_entered(body):
	if body.name == "player1":
		player_nearby = true


func _on_area_2d_body_exited(body):
	if body.name == "player1":
		player_nearby = false
