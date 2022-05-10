extends Node2D

var type
var category
var enemy_array = []
var built : bool = false
var enemy
var ready : bool = true


func _ready() -> void:
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]


func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
		if ready:
			fire()
	else:
		enemy = null


func turn() -> void:
	get_node("Turret").look_at(enemy.position)


func select_enemy():
	var enemy_progress_array = [] # how far the enemy has progressed along a path
	for i in enemy_array: # for every enemy in range, focus the one that it furthest away
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max() # which enemy object is closest to the end
	var enemy_index = enemy_progress_array.find(max_offset) # finds the enemy closest to the end
	enemy = enemy_array[enemy_index] # sets enemy to be the closest one to the end


func fire():
	ready = false
	if category == "Projectile":
		fire_gun()
	if category == "Missile":
		fire_missile()
	
	enemy.on_hit(GameData.tower_data[type]["damage"])
	yield(get_tree().create_timer(GameData.tower_data[type]["rof"]), "timeout")
	ready = true

func _on_Range_body_entered(body: Node) -> void:
	enemy_array.append(body.get_parent())


func _on_Range_body_exited(body: Node) -> void:
	enemy_array.erase(body.get_parent())


func fire_gun():
	$AnimationPlayer.play("Fire")


func fire_missile():
	pass



