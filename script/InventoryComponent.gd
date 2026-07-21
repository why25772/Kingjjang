extends Node

class_name InventoryComponent


signal inventory_changed


@export var max_slot: int = 40


var items: Array[InventoryItem] = []


func get_items() -> Array[InventoryItem]:
    return items


func get_count() -> int:
    return items.size()


func is_full() -> bool:
    return items.size() >= max_slot


func is_empty() -> bool:
    return items.is_empty()


func get_item(index: int) -> InventoryItem:
    if index < 0:
        return null

    if index >= items.size():
        return null

    return items[index]


func clear() -> void:
    items.clear()
    inventory_changed.emit()


func add_item(resource: ItemResource, amount: int = 1) -> bool:

    if resource == null:
        return false

    if resource.is_stackable():

        for inventory_item in items:

            if inventory_item.item == resource:

                var remain := resource.max_stack - inventory_item.amount

                if remain <= 0:
                    continue

                var add_amount :float = min(remain, amount)

                inventory_item.amount += add_amount
                amount -= add_amount

                if amount <= 0:
                    inventory_changed.emit()
                    return true

    while amount > 0:

        if items.size() >= max_slot:
            inventory_changed.emit()
            return false

        var inventory_item := InventoryItem.new()

        inventory_item.item = resource

        inventory_item.amount = min(amount, resource.max_stack)

        amount -= inventory_item.amount

        items.append(inventory_item)

    inventory_changed.emit()

    return true


func remove_item(resource: ItemResource, amount: int = 1) -> bool:

    for i in range(items.size() - 1, -1, -1):

        var inventory_item := items[i]

        if inventory_item.item != resource:
            continue

        if inventory_item.amount > amount:

            inventory_item.amount -= amount

            inventory_changed.emit()

            return true

        amount -= inventory_item.amount

        items.remove_at(i)

        if amount <= 0:

            inventory_changed.emit()

            return true

    inventory_changed.emit()

    return false


func has_item(resource: ItemResource, amount: int = 1) -> bool:

    var count := 0

    for inventory_item in items:

        if inventory_item.item == resource:
            count += inventory_item.amount

    return count >= amount
