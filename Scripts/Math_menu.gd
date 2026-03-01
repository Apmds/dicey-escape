extends Control


# 0 - Addition; 1 - Subtraction; 2 - Multiplication;
export var type = 0
export var num_1 = 1
export var num_2 = 1
export var can_answer = true
signal answered_right

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		0:
			$Equation_sign.text = "+"
			$Equation_sign.rect_position = Vector2(31.333, 14.667)
		1:
			$Equation_sign.text = "-"
			$Equation_sign.rect_position = Vector2(30, 13.333)
		2:
			$Equation_sign.text = "x"
			$Equation_sign.rect_position = Vector2(31.333, 14.667)
	$Num_1.text = str(num_1)
	$Num_2.text = str(num_2)
	$Answer.text = ""
	$Answer.grab_focus()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and $Answer.text.replace(" ", "") != "" and can_answer:
		if $Answer.text.is_valid_integer():
			match type:
				0:
					if int($Answer.text) == num_1 + num_2:
						emit_signal("answered_right")
					else:
						$AnimationPlayer.play("wrong_answer", -1, 2, false)
						$Answer.text = ""
				1:
					if int($Answer.text) == num_1 - num_2:
						emit_signal("answered_right")
					else:
						$AnimationPlayer.play("wrong_answer", -1, 2, false)
						$Answer.text = ""
				2:
					if int($Answer.text) == num_1 * num_2:
						emit_signal("answered_right")
					else:
						$AnimationPlayer.play("wrong_answer", -1, 2, false)
						$Answer.text = ""
		else:
			$Answer.text = ""


