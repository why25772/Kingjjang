extends Resource

class_name ItemResource


enum ItemType
{
    EQUIPMENT,
    CONSUMABLE,
    MATERIAL,
    QUEST
}


@export var id: String = ""

@export var item_name: String = ""

@export_multiline var description: String = ""

@export var icon: Texture2D

@export var item_type: ItemType

@export var max_stack: int = 1

@export var sell_price: int = 0

@export var rarity: int = 0


func is_stackable() -> bool:

    return max_stack > 1
