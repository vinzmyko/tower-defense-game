extends Node2D

signal game_finished(result)

var map_node

var build_mode : bool = false
var build_valid : bool = false
var build_location
var build_tile
var build_type : String

var current_wave : int = 0
var enemies_in_wave : int = 0

var base_health : int = 100


func _ready() -> void:
	map_node = get_node("Map1")
	
	# Goes through all the nodes that have the group "build_buttons" and connects the pressed signal
	# to them, in which if pressed run the "initiate_build_mode" function
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])


func _process(delta: float) -> void:
	if build_mode == true:
		update_tower_preview()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()


##
## Wave Functions
##

func start_next_wave():
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2), "timeout")
	spawn_enemies(wave_data)


func retrieve_wave_data():
	var wave_data = [["BlueTank", 3.0], ["BlueTank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data


func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instance()
		new_enemy.connect("base_damage", self, "on_base_damage")
		map_node.get_node("Path").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]), "timeout")


##
## Building Functions
##
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "T1" #Need to remember the build type so you need need to keep on clicking
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())


func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	# TowerExclusion are the areas where you can't build, the map only has roads and trees, obv you can't
	# build ontop of that, thus you refference that if a location is valid or not valid
	var current_tile = map_node.get_node("TowerExclusion").world_to_map(mouse_position) # Returns the
	# tile coordinate of where the mouse is
	var tile_position = map_node.get_node("TowerExclusion").map_to_world(current_tile) # Returns the
	# position of the tile in world view which is the top left position of the tile
	
	if map_node.get_node("TowerExclusion").get_cellv(current_tile) == -1:
		# If no tile is loaded there "-1", so if no tile is on that position make it so you can place
		# a tower there
		get_node("UI").update_tower_preview(tile_position, "ad54ff3c") # Green
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position, "adff4545") # Red
		build_valid = false


func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free() # Removes the drag texture


func verify_and_build():
	if build_valid:
		## Test to see if player has enough cash
		# Remember to set the Mouse filter to ignore
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.category = GameData.tower_data[build_type]["category"]
		new_tower.type = build_type
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cellv(build_tile, 5)


func on_base_damage(damage):
	base_health -= damage
	if base_health <= 0:
		emit_signal("game_finished", false)
	else:
		$UI.update_health_bar(base_health)
