extends Control

var sound_button_on = preload("res://Assets/Buttons/Button_sound.png")
var sound_button_off = preload("res://Assets/Buttons/Button_sound_off.png")
var sound_button_on_pressed = preload("res://Assets/Buttons/Button_sound_pressed.png")
var sound_button_off_pressed = preload("res://Assets/Buttons/Button_sound_off_pressed.png")


func _ready():
	$AnimationPlayer.play("Open_scene")

func _on_Play_button_pressed():
	$Select_sound.play()
	$AnimationPlayer.play("Play_game")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_Credits_button_pressed():
	$Select_sound.play()
	$AnimationPlayer.play("Open_credits")


func _on_Back_button_pressed():
	$Select_sound.play()
	$AnimationPlayer.play("Close_credits")


func _on_Font_button_pressed():
	$Select_sound.play()
	OS.shell_open("https://www.1001fonts.com/coolville-font.html")


func _on_Sfxr_button_pressed():
	$Select_sound.play()
	OS.shell_open("https://www.drpetter.se/project_sfxr.html")


func _on_Sound_button_toggled(button_pressed):
	$Select_sound.play()
	if button_pressed:
		AudioServer.set_bus_mute(1, true)
		$Sound_button.texture_normal = sound_button_off_pressed
		$Sound_button.texture_pressed = sound_button_off
	else:
		AudioServer.set_bus_mute(1, false)
		$Sound_button.texture_normal = sound_button_on
		$Sound_button.texture_pressed = sound_button_on_pressed
