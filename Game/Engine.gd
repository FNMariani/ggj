extends "res://Game/BaseEnemy.gd"

onready var Argos = preload("res://Game/Argos.tscn") 
onready var Enemy2 = preload("res://Game/Enemy2.tscn") 
onready var Enemy3 = preload("res://Game/Enemy3.tscn") 

onready var Projectile = preload("res://Enemies/Engine/Projectile.tscn")

onready var anim_player = $AnimationPlayer

export var shield = 3

func _ready():
	._ready()
	randomize()
	shield_activated = true
	play_anim("main_anim")
	
func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)

func _process(delta):
	._process(delta)

func receive_damage(amount):
	if(shield_activated):
		print("damaged shield")
		shield -= amount
		#TODO define boss status
		$Shield.modulate.a = $Shield.modulate.a/2
		if(shield <= 0):
			remove_shield()
	else:
		print("damaged health")
		health -= amount
		if(health <= 0):
			kill()

func remove_shield():
	$Shield.visible = false
	shield_activated = false

func spawn_enemy():
	var enemy_instance = Argos.instance()
	
	var points = $SpawnPoints.get_children()
	var point = points[randi() % points.size()]
	#print(point.name)
	
	enemy_instance.global_position = point.global_position
	get_tree().current_scene.add_child(enemy_instance)

func _on_EnemyCreationTimer_timeout():
	print("enemy created")
	spawn_enemy()

func _on_ShootTimer_timeout():
	print("projectile created")
	var projectile = Projectile.instance()
	projectile.global_position = global_position
	get_tree().current_scene.add_child(projectile)
