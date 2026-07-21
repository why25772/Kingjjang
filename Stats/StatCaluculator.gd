extends RefCounted
class_name StatCalculator


static func calculate(base: float, modifiers: Array[StatModifier]) -> float:

    var flat: float = 0.0
    var percent: float = 0.0
    var final_multiplier: float = 1.0

    for modifier in modifiers:

        match modifier.modifier_type:

            StatModifier.ModifierType.FLAT:
                flat += modifier.value

            StatModifier.ModifierType.PERCENT:
                percent += modifier.value

            StatModifier.ModifierType.FINAL:
                final_multiplier *= (1.0 + modifier.value)

    return ((base + flat) * (1.0 + percent)) * final_multiplier
