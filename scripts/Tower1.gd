extends StaticBody2D

@onready var health = 50;
@onready var healthBar = $towerHealth
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	healthBar.value = health

func take_damage(amount):
	health -= amount
	if health <= 0:
		pass #game over
