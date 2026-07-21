extends Node

class_name DamageSystem


static func apply(
    context: CombatContext,
    health: HealthComponent
) -> void:

    if context == null:
        return

    if health == null:
        return

    calculate(context, health)

    health.take_damage(context.final_damage)


static func calculate(
    context: CombatContext,
    health: HealthComponent
) -> void:

    var damage := context.base_damage

    var stat := health.stat_component

    if stat != null:

        if !context.attack_resource.ignore_defense:

            damage -= stat.get_stat(StatType.Type.DEFENSE)

        damage = max(damage, 1)

    if context.attack_resource.critical_enabled:

        if randf() <= context.critical_rate:

            context.critical = true

            damage *= context.critical_damage

    if context.attacker != null:

        var attacker_stat := context.attacker.get_node_or_null("StatComponent")

        if attacker_stat != null:

            damage *= (
                1.0
                + attacker_stat.get_stat(
                    StatType.Type.FINAL_DAMAGE
                ) / 100.0
            )

    context.final_damage = int(max(damage, 1))
