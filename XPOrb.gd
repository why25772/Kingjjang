extends Node3D

@export var exp_amount := 5
@export var move_speed := 8.0

var target: Player = null

@onready var sprite: Sprite3D = $Sprite3D


func _process(delta):

    if target == null:
        return

    global_position = global_position.move_toward(
        target.global_position,
        move_speed * delta
    )

    sprite.rotate_y(delta * 5.0)


func _on_detect_area_body_entered(body):

    if body is Player:

        target = body


func _on_pickup_area_body_entered(body):

    if body is Player:

        body.add_exp(exp_amount)

        queue_free()
