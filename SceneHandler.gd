extends Node

func _ready() -> void:
	load_main_menu()
	
func load_main_menu():
	get_node("MainMenu/M/VB/New Game").connect("pressed", self, "on_new_game_pressed")
	get_node("MainMenu/M/VB/Quit").connect("pressed", self, "on_quit_pressed")


func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/Main Scenes/GameScene.tscn").instance()
	game_scene.connect("game_finished", self, "unload_game")
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()


func unload_game(result):
	$GameScene.queue_free()
	var main_menu = preload("res://Scenes/UI/MainMenu.tscn")
	#add_child(main_menu)
	load_main_menu()


