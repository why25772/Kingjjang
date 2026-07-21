extends Node

class_name MovementComponent


@export var acceleration: float = 12.0
@export var deceleration: float = 16.0


var player: Player
var stat: StatComponent

var last_direction := Vector3.FORWARD


func _ready() -> void:

    player = get_parent() as Player

    if player == null:
        push_error("MovementComponent는 Player의 자식이어야 합니다.")
        return

    stat = player.get_node("StatComponent") as StatComponent


func update_movement(delta: float) -> void:

    var input := Input.get_vector(
        "ui_left",
        "ui_right",
        "ui_up",
        "ui_down"
    )

    var direction := Vector3(input.x, 0.0, input.y)

    if direction.length() > 0.0:

        direction = direction.normalized()

        last_direction = direction
        player.last_direction = direction
        
        player.velocity.x = move_toward(
            player.velocity.x,
            direction.x * stat.move_speed,
            acceleration * stat.move_speed * delta
        )

        player.velocity.z = move_toward(
            player.velocity.z,
            direction.z * stat.move_speed,
            acceleration * stat.move_speed * delta
        )

    else:

        player.velocity.x = move_toward(
            player.velocity.x,
            0.0,
            deceleration * stat.move_speed * delta
        )

        player.velocity.z = move_toward(
            player.velocity.z,
            0.0,
            deceleration * stat.move_speed * delta
        )

    player.move_and_slide()
