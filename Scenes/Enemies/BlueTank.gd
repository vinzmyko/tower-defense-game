extends PathFollow2D

var speed = 150
var hp = 50

onready var health_bar = $HealthBar
onready var impact_area = $Impact
var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")

func _ready() -> void:
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta):
	set_offset(get_offset() + speed * delta)
	health_bar.set_position(position - Vector2(30, 30))


func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()


func on_destroy():
	$KinematicBody2D.queue_free() # deletes this kinematic body meaning it's gone for the turrets enemy
	# list
	yield(get_tree().create_timer(0.2), "timeout") # waits 0.2s for the last impact animation to show
	self.queue_free()


func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos) # sets a random impact location
	var new_impact = projectile_impact.instance() # instance the animation
	new_impact.position = impact_location # put animation to the new rng location
	impact_area.add_child(new_impact) # add it as a child under impact position 2d
