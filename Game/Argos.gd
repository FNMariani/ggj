extends KinematicBody2D

var player = null
const MOVE_SPEED = 200
onready var raycast = $RayCast2D

var killed = false

var player_already_saw = false

export var health = 3
var can_move = true

#Shield variables
var shield_activated = false
var timer = null
export var delay = 5

##node path for the ai 
export (NodePath) var path

func _ready():
	set_player() 
	
func _physics_process(delta):
	if can_move:
		if player_already_saw:
			if player == null:
				print("p null")
				return
		
			var vec_to_player = player.global_position - global_position
			vec_to_player = vec_to_player.normalized()
			global_rotation = atan2(vec_to_player.y, vec_to_player.x)
			var collision = move_and_collide(vec_to_player * MOVE_SPEED * delta)
			
			if collision :
				var obj_coll = collision.collider 
				
				if obj_coll:
					if obj_coll.is_in_group("walls"):
						print("Wall collision")
						kill()
					
		if raycast.is_colliding():
			var coll = raycast.get_collider()
			if coll.name == "Player":
				get_tree().change_scene("res://Menu.tscn")

func _process(delta):
	if killed:
		if $Explosion.finished:
			queue_free()

func receive_damage(amount):
	if(!shield_activated):
		if(health <= 0):
			kill()
			return
		print("damaged")
		start_shield()
		health -= amount

func kill():
	print("kill")
	can_move = false	
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	$Explosion.visible = true
	$Sprite.visible = false
	$Explosion.play_anim("main_explosion")
	killed = true

func set_player():
	player = get_tree().current_scene.get_node("Player")
	
func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		player_already_saw = true

func start_shield():
	create_timer()
	$Shield.visible = true
	shield_activated = true

func stop_shield():
	$Shield.visible = false
	shield_activated = false
		
func create_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(delay)
	timer.connect("timeout", self, "stop_shield")
	add_child(timer)
	timer.start()
