extends Area3D

class_name Projectile

@export var speed := 10.0

var direction := Vector3.ZERO
var owner_node: Node
var context: CombatContext


func _physics_process(delta: float) -> void:

    position += direction * speed * delta


func _on_area_entered(area: Area3D) -> void:

    if !(area is Hurtbox):
        return

    var hurtbox := area as Hurtbox

    if hurtbox.get_parent() == owner_node:
        return

    context.target = hurtbox

    hurtbox.receive_hit(context)

    queue_free()
