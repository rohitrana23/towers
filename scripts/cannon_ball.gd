extends Area2D

@export var speed: float = 600.0
@export var gravity1: float = 200

var direction = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	velocity = direction * speed

func _physics_process(delta):
	velocity.y += gravity1 * delta
	position += velocity * delta
