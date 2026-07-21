extends Node

class_name SkillComponent


signal skill_used(skill: AttackResource)
signal skill_failed(skill: AttackResource)


@export var stat_component: StatComponent
@export var attack_component: AttackComponent


var skills: Array[AttackResource] = []

var _cooldowns: Dictionary = {}


func _process(delta: float) -> void:
    if _cooldowns.is_empty():
        return

    var remove_list: Array[AttackResource] = []

    for skill in _cooldowns.keys():
        _cooldowns[skill] -= delta

        if _cooldowns[skill] <= 0.0:
            remove_list.append(skill)

    for skill in remove_list:
        _cooldowns.erase(skill)


func add_skill(skill: AttackResource) -> void:
    if skill == null:
        return

    if skills.has(skill):
        return

    skills.append(skill)


func remove_skill(skill: AttackResource) -> void:
    skills.erase(skill)
    _cooldowns.erase(skill)


func has_skill(skill: AttackResource) -> bool:
    return skills.has(skill)


func can_use(skill: AttackResource) -> bool:
    if skill == null:
        return false

    if !skills.has(skill):
        return false

    if _cooldowns.has(skill):
        return false

    if attack_component.is_attacking():
        return false
    if stat_component != null:
        if stat_component.current_mp < skill.mp_cost:
            return false
    return true


func use_skill(skill: AttackResource) -> bool:
    if !can_use(skill):
        skill_failed.emit(skill)
        return false

    _cooldowns[skill] = skill.cooldown
    stat_component.current_mp -= skill.mp_cost
    attack_component.attack(skill)

    skill_used.emit(skill)

    return true


func get_remaining_cooldown(skill: AttackResource) -> float:
    if !_cooldowns.has(skill):
        return 0.0

    return _cooldowns[skill]
