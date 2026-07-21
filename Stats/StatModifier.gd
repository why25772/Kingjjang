extends Resource
class_name StatModifier

enum ModifierType {
    FLAT,
    PERCENT,
    FINAL
}

var stat: StatType.Type
var modifier_type: ModifierType
var value: float

func _init(
    p_stat: StatType.Type,
    p_modifier_type: ModifierType,
    p_value: float
):
    stat = p_stat
    modifier_type = p_modifier_type
    value = p_value
