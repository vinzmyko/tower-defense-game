extends Node2D

var enemy_array = []
var built : bool = false
var enemy


func _ready() -> void:
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[self.get_name()]["range"]


func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
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


func _on_Range_body_entered(body: Node) -> void:
	enemy_array.append(body.get_parent())
	print(enemy_array)


func _on_Range_body_exited(body: Node) -> void:
	enemy_array.erase(body.get_parent())

