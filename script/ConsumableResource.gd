extends ItemResource

class_name ConsumableResource


enum ConsumeType
{
    NONE,
    HEAL_HP,
    HEAL_MP,
    RESTORE_HP_MP,
    ADD_BUFF
}


@export var consume_type: ConsumeType = ConsumeType.NONE

@export var value: int = 0

@export var buff: BuffResource

@export var consume_on_use: bool = true


func use(stat_component: StatComponent) -> bool:

    if stat_component == null:
        return false

    match consume_type:

        ConsumeType.HEAL_HP:
            stat_component.heal(value)

        ConsumeType.HEAL_MP:
            stat_component.recover_mp(value)

        ConsumeType.RESTORE_HP_MP:
            stat_component.heal(value)
            stat_component.recover_mp(value)

        ConsumeType.ADD_BUFF:
            if buff:
                stat_component.add_buff(buff)

        _:
            return false

    return true
