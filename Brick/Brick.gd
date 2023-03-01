extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

var powerup_prob = 0.1

func _ready():
	randomize()
	position = new_position
	if score >= 100:
		$ColorRect.color = Color8(25,113,194)
	elif score >= 90:
		$ColorRect.color = Color8(28,126,214)
	elif score >= 80:
		$ColorRect.color = Color8(34,139,230)
	elif score >= 70:
		$ColorRect.color = Color8(51,154,240)
	elif score >= 60:
		$ColorRect.color = Color8(77,171,247)
	elif score >= 50:
		$ColorRect.color = Color8(116,192,252)
	elif score >= 40:
		$ColorRect.color = Color8(165,216,255)
	else:
		$ColorRect.color = Color8(208,235,255)

func _physics_process(_delta):
	if dying and not $Bubbles.emitting:
		queue_free()

func hit(_ball):
	var brick_sound = get_node_or_null("/root/Game/_Sound")
	if brick_sound != null:
		brick_sound.play()
	die()

func die():
	dying = true
	collision_layer = 0
	$ColorRect.hide()
	Global.update_score(score)
	if not Global.feverish:
		Global.update_fever(score)
	get_parent().check_level()
	$Bubbles.emitting = true
	if randf() < powerup_prob:
		var Powerup_Container = get_node_or_null("/root/Game/Powerup_Container")
		if Powerup_Container != null:
			var Powerup = load("res://Powerups/Powerup.tscn")
			var powerup = Powerup.instance()
			powerup.position = position
			Powerup_Container.call_deferred("add_child", powerup)
