extends CharacterBody2D

@export var cannonball_scene: PackedScene
@export var fire_cooldown: float = 1.0
@export var rotate_speed: float = 60.0  # degrees per second
var can_fire = true
var player_nearby = false
var rotating_up = true  # Direction flag: true = up, false = down

@onready var bullet_spawn = $Position2D
@onready var sprite = $"."

func _physics_process(delta):
	# Only rotate if player is near the cannon
	if player_nearby:
		if rotating_up:
			rotation_degrees -= rotate_speed * delta
			if rotation_degrees <= -90:
				rotation_degrees = -90
				rotating_up = false
		else:
			rotation_degrees += rotate_speed * delta
			if rotation_degrees >= 0:
				rotation_degrees = 0
				rotating_up = true

		# Fire cannonball if "fire" input is pressed and cannon is ready
		if Input.is_action_just_pressed("fire") and can_fire:
			fire()

func fire():
	var cannonball = cannonball_scene.instantiate()
	cannonball.global_position = bullet_spawn.global_position
	cannonball.rotation = global_rotation  # Use global rotation to set the firing angle
	cannonball.direction = Vector2.RIGHT.rotated(global_rotation)
	get_tree().current_scene.add_child(cannonball)

	# Handle fire cooldown
	can_fire = false
	await get_tree().create_timer(fire_cooldown).timeout
	can_fire = true


func _on_area_2d_body_entered(body):
	if body.name == "player1":
		player_nearby = true


func _on_area_2d_body_exited(body):
	if body.name == "player1":
		player_nearby = false
