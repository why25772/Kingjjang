extends Node

class_name AttackComponent

signal attack_started(resource: AttackResource)
signal attack_finished(resource: AttackResource)

@export var stat_component: StatComponent
@export var hitbox_spawner: HitboxSpawner

var _spawned_hitbox: Hitbox
var _is_attacking := false
var _current_attack: AttackResource


func is_attacking() -> bool:
    return _is_attacking


func attack(resource: AttackResource) -> void:
    if resource == null:
        return

    if _is_attacking:
        return

    _current_attack = resource
    _is_attacking = true

    attack_started.emit(resource)


func attack_hit() -> void:

    var player := get_parent() as Player

    if player == null:
        return

    if _current_attack == null:
        return

    var context := CombatContext.new()

    context.attack_resource = _current_attack

    context.base_damage = int(
        stat_component.get_stat(StatType.Type.ATTACK) * _current_attack.power
    )

    context.critical_rate = (
        stat_component.get_stat(StatType.Type.CRIT_RATE) / 100.0
    )

    context.critical_damage = (
        stat_component.get_stat(StatType.Type.CRIT_DAMAGE) / 100.0
    )

    context.damage_type = &"Physical"
    context.knockback = _current_attack.knockback

    match _current_attack.attack_type:

        AttackResource.AttackType.MELEE:
        
            if hitbox_spawner != null:

                _spawned_hitbox = hitbox_spawner.spawn(
                    player,
                    _current_attack,
                    context
                )

        AttackResource.AttackType.PROJECTILE:

            if _current_attack.projectile_scene == null:
                return

            var projectile := _current_attack.projectile_scene.instantiate() as Projectile

            if projectile == null:
                return

            player.get_parent().add_child(projectile)

            projectile.global_position = player.global_position
            projectile.speed = _current_attack.projectile_speed
            projectile.owner_node = player
            projectile.context = context

            var dir := player.last_direction.normalized()

            if dir == Vector3.ZERO:
                dir = Vector3.FORWARD

            projectile.direction = dir

        AttackResource.AttackType.AREA:

            if hitbox_spawner != null:

                _spawned_hitbox = hitbox_spawner.spawn(
                    player,
                    _current_attack,
                    context
                )


func attack_end() -> void:

    if _spawned_hitbox != null:

        _spawned_hitbox.deactivate()
        _spawned_hitbox.queue_free()
        _spawned_hitbox = null
    _is_attacking = false

    attack_finished.emit(_current_attack)

    _current_attack = null
