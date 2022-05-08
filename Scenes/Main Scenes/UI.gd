extends CanvasLayer


func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Scenes/Turrets/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower") #Sets name in scene tree
	drag_tower.modulate = Color("ad54ff3c")
	
	var range_texture = Sprite.new()
	range_texture.position = Vector2(32, 32)
	var scaling : float = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/Tilesets/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0) #Moves "TowerPreview" up on in the tree so it's rendered
	#behind some objects, basically making it the backmost image


func update_tower_preview(new_position, color):
	get_node("TowerPreview").rect_position = new_position
	# Only set the color if, the colour is different from what it always was, this is good
	# as it only get's called when the colour changes
	if get_node("TowerPreview/DragTower").modulate != Color(color): # If colour is not the same as were
		# getting received then change it to that colour
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite").modulate = Color(color)
		
	
