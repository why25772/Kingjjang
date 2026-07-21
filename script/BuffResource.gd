extends Resource

class_name BuffResource


@export var id: String = ""

@export var buff_name: String = ""

@export_multiline var description: String = ""

@export var icon: Texture2D


@export var duration: float = 5.0

@export var is_stackable: bool = false

@export var max_stack: int = 1


@export var modifiers: Array[StatModifier] = []


func get_modifiers() -> Array[StatModifier]:

    return modifiers


func add_modifier(modifier: StatModifier) -> void:

    modifiers.append(modifier)


func remove_modifier(modifier: StatModifier) -> void:

    modifiers.erase(modifier)
