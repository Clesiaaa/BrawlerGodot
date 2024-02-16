extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
var health = 100
var ai_is_alive = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_in_range = false
@onready var audio_jab = $jab_sound
@onready var audio_cross = $cross_sound

func _physics_process(delta):
	
	velocity.y += gravity * delta
	move_and_slide()
		
	if player_chase:
		position += (player.position - position)/speed
		$AnimationAI.play("ai_run")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	if ai_is_alive == false:
		self.queue_free()
		get_tree().change_scene_to_file("res://scene/win.tscn")
	
func load_health_bar(health_point_lost):
	$health_bar.value -= health_point_lost

func _on_detection_area_body_entered(body): #!
	player = body
	player_chase = true #true == enable the chase and false disable the chase
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func deal_with_damage(hit):
		health = health - hit
		load_health_bar(hit)
		#print("AI health ", health)
		if health <= 0:
			ai_is_alive = false
			
func _on_ai_hitbox_area_entered(area):
	if area.name == "player_jab":
		deal_with_damage(1)
	elif area.name == "player_cross":
		deal_with_damage(3)

func attack_2():
	audio_cross.play()
	$AnimationAI.play("ai_cross")
	
func attack_1():
	audio_jab.play()
	$AnimationAI.play("ai_jab")

func _on_attack_range_area_entered(area):
	if area.name == "player_hitbox":
		player_in_range = true
		player_chase = false
		attack_2()
		
func _on_attack_range_jab_area_entered(area):
	if area.name == "player_hitbox":
		player_in_range = true
		player_chase = false
		attack_1()

func _on_attack_range_area_exited(area):
	if area.name == "player_hibox":
		player_in_range = false

func _on_attack_range_jab_area_exited(area):
	if area.name == "player_hitbox":
		player_in_range = false
