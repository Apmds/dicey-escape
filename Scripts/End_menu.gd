extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("open_scene")

func _on_Main_menu_button_pressed():
	$Select_sound.play()
	$AnimationPlayer.play("close_scene")
	yield($AnimationPlayer,"animation_finished")
	get_tree().change_scene("res://Scenes/Main_menu.tscn")
