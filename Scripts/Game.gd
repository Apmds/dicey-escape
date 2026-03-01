extends Node2D

var RNG = RandomNumberGenerator.new()
var current_position = 1
var level = 1
var math_question = preload("res://Scenes/Math_menu.tscn")
var dust_particles = preload("res://Scenes/Dust_particles.tscn")
var enemy_timer_type = 0 # 0 for actual use and 1 for waiting 1 second
var game_on = true

# Called when the node enters the scene tree for the first time.
func _ready():
	RNG.randomize()
	$AnimationPlayer.play("start_game")
	yield($AnimationPlayer, "animation_finished")
	ask_question()
	$Enemy/Dice.scale = Vector2.ZERO
	$Enemy/Timer.wait_time = RNG.randi_range(5, 10)
	$Enemy/Timer.start()

func shake_camera(speed, time):
	for i in range(time):
		$Camera.offset.x = RNG.randi_range(-5, 5)
		$Camera.offset.y = RNG.randi_range(-5, 5)
		for j in range(speed):
			yield(get_tree(), "idle_frame")
	$Camera.offset = Vector2.ZERO

func ask_question():
	var math_question_instance = math_question.instance()
	match level:
		1:
			math_question_instance.type = 0
			math_question_instance.num_1 = RNG.randi_range(1, 7)
			math_question_instance.num_2 = RNG.randi_range(1, 7)
		2:
			if RNG.randf_range(0.0, 1.0) <= 0.5:
				math_question_instance.type = 0
				math_question_instance.num_1 = RNG.randi_range(3, 10)
				math_question_instance.num_2 = RNG.randi_range(5, 10)
			else:
				math_question_instance.type = 1
				math_question_instance.num_1 = RNG.randi_range(3, 10)
				math_question_instance.num_2 = RNG.randi_range(5, 10)
		3:
			var type_chance = RNG.randf_range(0.0, 1.0)
			if type_chance <= 0.4:
				math_question_instance.type = 0
				math_question_instance.num_1 = RNG.randi_range(7, 18)
				math_question_instance.num_2 = RNG.randi_range(7, 18)
			elif type_chance <= 0.8:
				math_question_instance.type = 1
				math_question_instance.num_1 = RNG.randi_range(7, 18)
				math_question_instance.num_2 = RNG.randi_range(7, 18)
			else:
				math_question_instance.type = 2
				math_question_instance.num_1 = RNG.randi_range(3, 6)
				math_question_instance.num_2 = RNG.randi_range(2, 7)
		4:
			if current_position != 23:
				var type_chance = RNG.randf_range(0.0, 1.0)
				if type_chance <= 0.3:
					math_question_instance.type = 0
					math_question_instance.num_1 = RNG.randi_range(10, 20)
					math_question_instance.num_2 = RNG.randi_range(10, 20)
				elif type_chance <= 0.3:
					math_question_instance.type = 1
					math_question_instance.num_1 = RNG.randi_range(10, 20)
					math_question_instance.num_2 = RNG.randi_range(10, 20)
				else:
					math_question_instance.type = 2
					math_question_instance.num_1 = RNG.randi_range(5, 10)
					math_question_instance.num_2 = RNG.randi_range(5, 10)
			else:
				math_question_instance.type = 0
				math_question_instance.num_1 = RNG.randi_range(15, 50)
				math_question_instance.num_2 = 100-math_question_instance.num_1
	math_question_instance.can_answer = true
	math_question_instance.name = "Math_menu"
	math_question_instance.connect("answered_right", self, "_on_question_right")
#	math_question_instance.connect("answered_wrong", self, "_on_question_wrong")
	add_child(math_question_instance)

func update_player(movement):
	shake_camera(2, 5)
	for i in range(abs(movement)):
		if movement > 0:
			if current_position + 1 < 25:
				$Player/Tween.interpolate_property($Player, "position", $Player.position, $Houses.get_node(str(current_position+1)).position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				current_position += 1
				$Player/Forwards_sound.play()
				var dust_particles_instance = dust_particles.instance()
				dust_particles_instance.position = $Player.position
				add_child(dust_particles_instance)
				$Player/Tween.start()
		else:
			if current_position - 1 > 0:
				$Player/Tween.interpolate_property($Player, "position", $Player.position, $Houses.get_node(str(current_position-1)).position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				current_position -= 1
				$Player/Backwards_sound.play()
				var dust_particles_instance = dust_particles.instance()
				dust_particles_instance.position = $Player.position
				add_child(dust_particles_instance)
				$Player/Tween.start()
	match current_position:
		1, 2, 3, 4, 5, 6:
			level = 1
			$Player.flip_h = false
		7, 8, 9, 10, 11, 12:
			level = 2
			$Player.flip_h = true
		13, 14, 15, 16, 17, 18:
			level = 3
			$Player.flip_h = false
		19, 20, 21, 22, 23, 24:
			level = 4
			$Player.flip_h = true
	if current_position == 24:
		game_on = false
		$AnimationPlayer.stop()
		$AnimationPlayer.play("kill_enemy")
		yield($AnimationPlayer, "animation_finished")
		get_tree().change_scene("res://Scenes/End_menu.tscn")

func _on_question_right():
	update_player(1)
	get_node("Math_menu").queue_free()
	yield(get_tree().create_timer(0.5), "timeout")
	if game_on:
		ask_question()

func _on_Timer_timeout():
	if enemy_timer_type == 0 and game_on:
		$AnimationPlayer.play("move_enemy")
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play_backwards("move_enemy")
		yield($AnimationPlayer, "animation_finished")
		$Enemy/Dice/AnimationPlayer.play("Show")
		yield($Enemy/Dice/AnimationPlayer, "animation_finished")
		$Enemy/Dice.scramble(5)
		yield($Enemy/Dice, "ended_scramble")
		update_player($Enemy/Dice.current_side * -1)
		enemy_timer_type = 1
		$Enemy/Timer.wait_time = 1
		$Enemy/Timer.start()
		yield($Enemy/Timer, "timeout")
	elif enemy_timer_type == 1 and game_on:
		enemy_timer_type = 0
		$Enemy/Dice/AnimationPlayer.play_backwards("Show")
		$Enemy/Timer.wait_time = RNG.randi_range(10, 15)
		$Enemy/Timer.start()


func _on_Pause_Button_toggled(button_pressed):
	$Select_sound.play()
	var button_pause = preload("res://Assets/Buttons/Button_pause.png")
	var button_pause_pressed = preload("res://Assets/Buttons/Button_pause_pressed.png")
	var button_resume = preload("res://Assets/Buttons/Button_resume.png")
	var button_resume_pressed = preload("res://Assets/Buttons/Button_resume_pressed.png")
	if button_pressed:
		$HUD/Pause_Button.rect_position = Vector2(451, 369)
		$HUD/Pause_Button.texture_normal = button_resume_pressed
		$HUD/Pause_Button.texture_pressed = button_resume
	else:
		$HUD/Pause_Button.rect_position = Vector2(891, 10)
		$HUD/Pause_Button.texture_normal = button_pause
		$HUD/Pause_Button.texture_pressed = button_pause_pressed
		if get_node_or_null("Math_menu") != null:
			$Math_menu/Answer.grab_focus()
	$HUD/Pause_menu.visible = button_pressed
	get_tree().paused = button_pressed
