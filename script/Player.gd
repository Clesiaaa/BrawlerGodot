extends CharacterBody2D

var ai_inattack_range = false
var ai_attack_cooldowon = true
var player_alive = true
var attack_ip = false

@export var speed = 600
@export var gravity = 30
@export var jump_force = 500

@onready var ap = $AnimationPlayer
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
		ap.play("Death")
		_on_animated_sprite_2d_animation_finished()
		#print("player is dead")#debug

func player_movements(delta):
	if !is_on_floor():
		velocity.y += gravity

		if velocity.y > 1000:
			velocity.y = 1000
			
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction

	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
			
	move_and_slide()
	load_animation(horizontal_direction)

func load_animation(horizontal_direction):
	
	if is_on_floor():
		if hurt == true and attack_ip == false:
			ap.play("Hurt")
		elif Input.is_action_pressed("attack_1"):
			ap.play("jab_khabob")
			audio_jab.play()
		elif Input.is_action_pressed("attack_2"):
			ap.play("cross_khabob")	
			audio_cross.play()
		elif horizontal_direction != 0 and attack_ip == false:
			ap.play("run_khabob")
		else:
			ap.play("idle_khabob")
			
	else:
		if velocity.y < 0 and attack_ip == false:
			ap.play("khabob_jump")

func load_health_bar(health_point_lost):
	$health_bar.value -= health_point_lost

func deal_with_damage(hit):
		health = health - hit
		load_health_bar(hit)
		print("player health ", health)#debug
		if health <= 0:
			player_alive = false

func _on_player_hitbox_area_entered(area):
	if area.name == "attack_2" or area.name == "jab_2":
		deal_with_damage(1)
	elif area.name == "attack_1" or area.name == "cross_2":
		deal_with_damage(3)

func _on_animated_sprite_2d_animation_finished():
	if  sprite.animation == "Death":
		get_tree().change_scene_to_file("res://scene/game_over.tscn")
