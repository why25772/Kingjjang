extends RefCounted
class_name StatType

enum Type {
    STR,
    DEX,
    INT,
    LUK,

    MAX_HP,
    MAX_MP,
    HP_REGEN,
    MP_REGEN,

    ATTACK,
    MAGIC_ATTACK,

    DEFENSE,
    MAGIC_DEFENSE,

    ATTACK_SPEED,
    MOVE_SPEED,

    CRIT_RATE,
    CRIT_DAMAGE,

    FINAL_DAMAGE
}

static func to_property(type: Type) -> String:
    match type:
        Type.STR:
            return "str"
        Type.DEX:
            return "dex"
        Type.INT:
            return "int_"
        Type.LUK:
            return "luk"

        Type.MAX_HP:
            return "max_hp"
        Type.MAX_MP:
            return "max_mp"

        Type.ATTACK:
            return "attack"
        Type.MAGIC_ATTACK:
            return "magic_attack"

        Type.DEFENSE:
            return "defense"
        Type.MAGIC_DEFENSE:
            return "magic_defense"

        Type.MOVE_SPEED:
            return "move_speed"
        Type.ATTACK_SPEED:
            return "attack_speed"

        Type.CRIT_RATE:
            return "crit_rate"
        Type.CRIT_DAMAGE:
            return "crit_damage"

        Type.FINAL_DAMAGE:
            return "final_damage"

    return ""
