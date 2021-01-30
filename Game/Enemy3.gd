extends "res://Game/BaseEnemy.gd"

func _ready():
	._ready()
	
func _physics_process(delta):
	.follow_player(delta)
