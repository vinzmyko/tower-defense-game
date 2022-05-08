extends Node2D

var map_node

var build_mode : bool = false
var build_valid : bool = false
var build_location
var build_tile
var build_type : String


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


func initiate_build_mode(tower_type):
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
	get_node("UI/TowerPreview").queue_free() # Removes the drag texture


func verify_and_build():
	if build_valid:
		## Test to see if player has enough cash
		# Remember to set the Mouse filter to ignore
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cellv(build_tile, 5)


