extends Resource

class_name InventoryItem


@export var item: Resource

@export var amount: int = 1


func add(count: int) -> void:

    amount += count


func remove(count: int) -> void:

    amount -= count

    if amount < 0:
        amount = 0


func is_empty() -> bool:

    return amount <= 0
