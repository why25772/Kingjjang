extends Area3D

class_name Hurtbox

signal hit_received(context: CombatContext)

@export var health_component: HealthComponent


func receive_hit(context: CombatContext) -> void:
    if context == null:
        return

    if health_component == null:
        return

    hit_received.emit(context)

    DamageSystem.apply(context, health_component)
