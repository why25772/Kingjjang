extends Node3D

@export var enemy_scene: PackedScene

@onready var player = $"../Player"

func _ready():
    spawn_enemy()

func spawn_enemy():
    var enemy = enemy_scene.instantiate()

    add_child(enemy)

    enemy.global_position = Vector3(5, 0, 5)
    enemy.target = player
