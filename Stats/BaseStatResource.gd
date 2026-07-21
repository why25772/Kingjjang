extends Resource
class_name BaseStatResource

# ===== 기본 능력치 =====
@export var str: int = 5
@export var dex: int = 5
@export var int_: int = 5
@export var luk: int = 5

# ===== 생존 =====
@export var max_hp: int = 100
@export var max_mp: int = 50
@export var hp_regen: float = 1.0
@export var mp_regen: float = 1.0

# ===== 공격 =====
@export var attack: int = 10
@export var magic_attack: int = 10
@export var attack_speed: float = 1.0

# ===== 방어 =====
@export var defense: int = 0
@export var magic_defense: int = 0

# ===== 이동 =====
@export var move_speed: float = 5.0

# ===== 치명타 =====
@export var crit_rate: float = 5.0
@export var crit_damage: float = 150.0

# ===== 최종 피해 =====
@export var final_damage: float = 0.0

func get_base_stat(stat: StatType.Type) -> Variant:

    match stat:

        StatType.Type.STR:
            return str

        StatType.Type.DEX:
            return dex

        StatType.Type.INT:
            return int_

        StatType.Type.LUK:
            return luk

        StatType.Type.MAX_HP:
            return max_hp

        StatType.Type.MAX_MP:
            return max_mp

        StatType.Type.HP_REGEN:
            return hp_regen

        StatType.Type.MP_REGEN:
            return mp_regen

        StatType.Type.ATTACK:
            return attack

        StatType.Type.MAGIC_ATTACK:
            return magic_attack

        StatType.Type.DEFENSE:
            return defense

        StatType.Type.MAGIC_DEFENSE:
            return magic_defense

        StatType.Type.ATTACK_SPEED:
            return attack_speed

        StatType.Type.MOVE_SPEED:
            return move_speed

        StatType.Type.CRIT_RATE:
            return crit_rate

        StatType.Type.CRIT_DAMAGE:
            return crit_damage

        StatType.Type.FINAL_DAMAGE:
            return final_damage

    return null
func set_base_stat(stat: StatType.Type, value: Variant) -> void:

    match stat:

        StatType.Type.STR:
            str = value

        StatType.Type.DEX:
            dex = value

        StatType.Type.INT:
            int_ = value

        StatType.Type.LUK:
            luk = value

        StatType.Type.MAX_HP:
            max_hp = value

        StatType.Type.MAX_MP:
            max_mp = value

        StatType.Type.HP_REGEN:
            hp_regen = value

        StatType.Type.MP_REGEN:
            mp_regen = value

        StatType.Type.ATTACK:
            attack = value

        StatType.Type.MAGIC_ATTACK:
            magic_attack = value

        StatType.Type.DEFENSE:
            defense = value

        StatType.Type.MAGIC_DEFENSE:
            magic_defense = value

        StatType.Type.ATTACK_SPEED:
            attack_speed = value

        StatType.Type.MOVE_SPEED:
            move_speed = value

        StatType.Type.CRIT_RATE:
            crit_rate = value

        StatType.Type.CRIT_DAMAGE:
            crit_damage = value

        StatType.Type.FINAL_DAMAGE:
            final_damage = value
