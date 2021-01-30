extends KinematicBody2D

var player = null
const MOVE_SPEED = 200

func _ready():
	set_player() 
	
func _physics_process(delta):
	follow_player(delta)

func set_player():
	player = get_tree().current_scene.get_node("Player")

func follow_player(delta):
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	var collision = move_and_collide(vec_to_player * MOVE_SPEED * delta)

	if collision :
		queue_free()
