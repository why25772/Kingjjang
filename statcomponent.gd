extends Node

class_name StatComponent

signal died
signal hp_changed(current_hp: int, max_hp: int)
signal mp_changed(current_mp: int, max_mp: int)
signal level_up_signal(level: int)
signal exp_changed(exp: int, max_exp: int)


@export var base_stat: BaseStatResource


# =========================
# 기본 능력치
# =========================

var str := 0
var dex := 0
var intelligence := 0
var luk := 0


# =========================
# 생존
# =========================

var max_hp := 100
var max_mp := 50

var hp := 100
var mp := 50

var hp_regen := 0.0
var mp_regen := 0.0


# =========================
# 공격
# =========================

var attack := 10
var magic_attack := 10

var attack_speed := 1.0


# =========================
# 방어
# =========================

var defense := 0
var magic_defense := 0


# =========================
# 이동
# =========================

var move_speed := 5.0


# =========================
# 치명타
# =========================

var crit_rate := 5.0
var crit_damage := 150.0


# =========================
# 최종 데미지
# =========================

var final_damage := 0.0


# =========================
# 레벨
# =========================

var level := 1
var exp := 0
var max_exp := 100
var skill_points := 0


# =========================
# 런타임
# =========================

var modifiers: Array[StatModifier] = []

var equipments: Array = []

var buffs: Array = []

var passives: Array = []


func _ready() -> void:

    refresh_stats()

    hp = max_hp
    mp = max_mp

    hp_changed.emit(hp, max_hp)
    mp_changed.emit(mp, max_mp)
    exp_changed.emit(exp, max_exp)


func refresh_stats() -> void:

    if base_stat == null:
        return

    var stat_list: Array[StatType.Type] = [
        StatType.Type.STR,
        StatType.Type.DEX,
        StatType.Type.INT,
        StatType.Type.LUK,

        StatType.Type.MAX_HP,
        StatType.Type.MAX_MP,
        StatType.Type.HP_REGEN,
        StatType.Type.MP_REGEN,

        StatType.Type.ATTACK,
        StatType.Type.MAGIC_ATTACK,
        StatType.Type.DEFENSE,
        StatType.Type.MAGIC_DEFENSE,

        StatType.Type.ATTACK_SPEED,
        StatType.Type.MOVE_SPEED,

        StatType.Type.CRIT_RATE,
        StatType.Type.CRIT_DAMAGE,

        StatType.Type.FINAL_DAMAGE
    ]

    for stat in stat_list:

        var base_value: Variant = base_stat.get_base_stat(stat)

        var stat_modifiers: Array[StatModifier] = []

        for modifier in modifiers:

            if modifier.stat == stat:
                stat_modifiers.append(modifier)

        var final_value = StatCalculator.calculate(float(base_value), stat_modifiers)

        if base_value is int:
            final_value = int(round(final_value))

        _set_runtime_stat(stat, final_value)

    hp = clamp(hp, 0, max_hp)
    mp = clamp(mp, 0, max_mp)

    hp_changed.emit(hp, max_hp)
    mp_changed.emit(mp, max_mp)

func _set_runtime_stat(stat: StatType.Type, value: Variant) -> void:

    match stat:

        StatType.Type.STR:
            str = value

        StatType.Type.DEX:
            dex = value

        StatType.Type.INT:
            intelligence = value

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


func add_modifier(modifier: StatModifier) -> void:

    modifiers.append(modifier)

    refresh_stats()

func get_stat(stat: StatType.Type) -> Variant:

    match stat:

        StatType.Type.STR:
            return str

        StatType.Type.DEX:
            return dex

        StatType.Type.INT:
            return intelligence 

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



func is_dead() -> bool:
    return hp <= 0

func remove_modifier(modifier: StatModifier, refresh := true) -> void:

    modifiers.erase(modifier)

    if refresh:
        refresh_stats()

func clear_modifiers(refresh := true) -> void:

    modifiers.clear()

    if refresh:
        refresh_stats()


func equip(equipment) -> void:

    if equipments.has(equipment):
        return

    equipments.append(equipment)

    if equipment.has_method("get_modifiers"):

        for modifier in equipment.get_modifiers():

            add_modifier(modifier)


func unequip(equipment) -> void:

    if !equipments.has(equipment):
        return

    equipments.erase(equipment)

    if equipment.has_method("get_modifiers"):

        for modifier in equipment.get_modifiers():

            remove_modifier(modifier)


func add_buff(buff) -> void:

    if buffs.has(buff):
        return

    buffs.append(buff)

    if buff.has_method("get_modifiers"):

        for modifier in buff.get_modifiers():

            add_modifier(modifier)


func remove_buff(buff) -> void:

    if !buffs.has(buff):
        return

    buffs.erase(buff)

    if buff.has_method("get_modifiers"):

        for modifier in buff.get_modifiers():

            remove_modifier(modifier)


func damage(amount: int) -> void:

    hp -= amount

    hp = clamp(hp, 0, max_hp)

    hp_changed.emit(hp, max_hp)

    if hp <= 0:
        died.emit()

func use_mp(amount: int) -> bool:

    if mp < amount:
        return false

    mp -= amount

    mp_changed.emit(mp, max_mp)

    return true


func recover_mp(amount: int) -> void:

    mp += amount

    mp = clamp(mp, 0, max_mp)

    mp_changed.emit(mp, max_mp)


func add_exp(amount: int) -> void:

    exp += amount

    while exp >= max_exp:

        exp -= max_exp

        level_up()

    exp_changed.emit(exp, max_exp)


func level_up() -> void:

    level += 1

    skill_points += 5

    max_exp = int(max_exp * 1.25)

    refresh_stats()

    hp = max_hp
    mp = max_mp

    level_up_signal.emit(level)

    hp_changed.emit(hp, max_hp)
    mp_changed.emit(mp, max_mp)
    exp_changed.emit(exp, max_exp)

func set_stat(stat: StatType.Type, value: Variant) -> void:

    _set_runtime_stat(stat, value)

    if stat == StatType.Type.MAX_HP:
        hp = clamp(hp, 0, max_hp)
        hp_changed.emit(hp, max_hp)

    elif stat == StatType.Type.MAX_MP:
        mp = clamp(mp, 0, max_mp)
        mp_changed.emit(mp, max_mp)
        
    
func has_enough_mp(cost: int) -> bool:
    return mp >= cost



func add_mp(amount: int) -> void:
    recover_mp(amount)
