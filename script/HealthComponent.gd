extends Node

class_name HealthComponent

signal damaged(amount: int)
signal healed(amount: int)
signal hp_changed(current: int, max_hp: int)
signal died

@export var stat_component: StatComponent

@export var invincible_time := 0.2

var current_hp := 0
var _invincible := false


func _ready() -> void:

    if stat_component == null:
        push_error("HealthComponent에 StatComponent를 연결하세요.")
        return

    current_hp = int(stat_component.get_stat(
        StatType.Type.MAX_HP
    ))


func get_hp() -> int:
    return current_hp


func get_max_hp() -> int:
    if stat_component == null:
        return 0

    return int(
        stat_component.get_stat(
            StatType.Type.MAX_HP
        )
    )


func is_dead() -> bool:
    return current_hp <= 0


func take_damage(amount: int) -> void:

    if amount <= 0:
        return

    if _invincible:
        return

    current_hp -= amount

    current_hp = max(current_hp, 0)

    damaged.emit(amount)
    hp_changed.emit(current_hp, get_max_hp())

    if current_hp <= 0:

        died.emit()

        return

    _start_invincible()


func heal(amount: int) -> void:

    if amount <= 0:
        return

    current_hp += amount

    current_hp = min(
        current_hp,
        get_max_hp()
    )

    healed.emit(amount)

    hp_changed.emit(
        current_hp,
        get_max_hp()
    )


func set_full_hp() -> void:

    current_hp = get_max_hp()

    hp_changed.emit(
        current_hp,
        get_max_hp()
    )


func _start_invincible() -> void:

    if invincible_time <= 0.0:
        return

    _invincible = true

    await get_tree().create_timer(
        invincible_time
    ).timeout

    _invincible = false
