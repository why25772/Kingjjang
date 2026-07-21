extends Node

class_name HitboxSpawner


func spawn(
    player: Player,
    attack: AttackResource,
    context: CombatContext
) -> Hitbox:
    
    if attack == null:
        return null

    if attack.hitbox_scene == null:
        return null

    var hitbox := attack.hitbox_scene.instantiate() as Hitbox

    player.add_child(hitbox)

    hitbox.context = context
    hitbox.owner_node = player

    var dir := player.last_direction.normalized()

    if dir == Vector3.ZERO:
        dir = Vector3.FORWARD

    var right := Vector3(dir.z, 0.0, -dir.x)

    hitbox.position = dir * attack.range
    hitbox.position += right * attack.offset.x
    hitbox.position += Vector3.UP * attack.offset.y
    hitbox.position += dir * attack.offset.z

    hitbox.rotation_degrees = attack.rotation
    hitbox.scale = attack.scale

    hitbox.activate()
    hitbox.activate()

    if attack.duration > 0.0:
        _destroy_hitbox_later(hitbox, attack.duration)

    return hitbox


func _destroy_hitbox_later(hitbox: Hitbox, duration: float) -> void:
    await get_tree().create_timer(duration).timeout

    if is_instance_valid(hitbox):
        hitbox.deactivate()
        hitbox.queue_free()
