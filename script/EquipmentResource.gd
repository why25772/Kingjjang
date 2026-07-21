extends ItemResource

class_name EquipmentResource


enum EquipmentType {
    WEAPON,
    HELMET,
    ARMOR,
    GLOVES,
    BOOTS,
    RING,
    NECKLACE
}


@export var equipment_type: EquipmentType = EquipmentType.WEAPON


@export var level_requirement: int = 1


@export var price: int = 0


@export var modifiers: Array[StatModifier] = []


func get_modifiers() -> Array[StatModifier]:

    return modifiers


func add_modifier(modifier: StatModifier) -> void:

    modifiers.append(modifier)


func remove_modifier(modifier: StatModifier) -> void:

    modifiers.erase(modifier)
