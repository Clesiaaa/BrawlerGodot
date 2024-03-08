extends CharacterBody2D

var ai_inattack_range = false
var ai_attack_cooldowon = true
var player_alive = true
var attack_ip = false

@export var speed = 600
@export var gravity = 30
@export var jump_force = 500

@onready var ap = $AnimationAI
@onready var sprite = $AnimatedSprite2D

@onready var audio_jab = $jab_sound
@onready var audio_cross = $cross_sound

@export var maxhealth = 100
@onready var health = maxhealth
@export var hurt = false

func _physics_process(delta):
	
	player_movements(delta)
	
	if health <= 0:
		player_alive = false #game over
		health = 0
		ap.play("ai_death")
		_on_animated_sprite_2d_animation_finished()
		#print("player is dead")#debug

func player_movements(delta):
	if !is_on_floor():
		velocity.y += gravity

		if velocity.y > 1000:
			velocity.y = 1000
			
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = speed * horizontal_direction

	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
			
	move_and_slide()
	load_animation(horizontal_direction)

func load_animation(horizontal_direction):
	
	if is_on_floor():
		if hurt == true and attack_ip == false:
			ap.play("ai_hurt")
		elif Input.is_action_pressed("attak_1_player2"):
			ap.play("ai_jab")
			audio_jab.play()
		elif Input.is_action_pressed("attack_2_player2"):
			ap.play("ai_cross")	
			audio_cross.play()
		elif horizontal_direction != 0 and attack_ip == false:
			ap.play("ai_run")
		else:
			ap.play("ai_idle")		
	else:
		if velocity.y < 0 and attack_ip == false:
			ap.play("ai_jump")

func load_health_bar(health_point_lost):
	$health_bar.value -= health_point_lost

func deal_with_damage(hit):
		health = health - hit
		load_health_bar(hit)
		print("player_2 health ", health)#debug
		if health <= 0:
			player_alive = false

func _on_animated_sprite_2d_animation_finished():
	if  sprite.animation == "ai_death":
		get_tree().change_scene_to_file("res://scene/game_over.tscn")


func _on_player_2_hitbox_area_entered(area):
	if area.name == "player_jab":
		deal_with_damage(1)
	elif area.name ==  "player_cross":
		deal_with_damage(3)
