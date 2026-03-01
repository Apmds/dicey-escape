extends Sprite

var sides = {
	1: 5,
	2: 4,
	3: 3,
	4: 2,
	5: 1,
	6: 0,
}
var current_side = 6
var RNG = RandomNumberGenerator.new()
signal ended_scramble

func _ready():
	RNG.randomize()
	frame = sides.get(current_side)

func scramble(times):
	for i in range(times):
		match RNG.randi_range(1, 4):
			1:
				$AnimationPlayer.play("Turn_up")
			2:
				$AnimationPlayer.play("Turn_down")
			3:
				$AnimationPlayer.play("Turn_left")
			4:
				$AnimationPlayer.play("Turn_right")
		yield($AnimationPlayer, "animation_finished")
		var side_chance = RNG.randf_range(0.0, 1.0)
		if side_chance < 0.1:
			current_side = 6
		elif side_chance < 0.25:
			current_side = 5
		elif side_chance < 0.45:
			current_side = 4
		elif side_chance < 0.70:
			current_side = 3
		elif side_chance < 0.90:
			current_side = 2
		else:
			current_side = 1
		frame = sides.get(current_side)
	emit_signal("ended_scramble")
