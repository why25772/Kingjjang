extends Node

class_name EquipmentComponent


signal equipment_changed


@export var stat_component: StatComponent


var weapon: EquipmentResource
var helmet: EquipmentResource
var armor: EquipmentResource
var gloves: EquipmentResource
var boots: EquipmentResource
var ring: EquipmentResource
var necklace: EquipmentResource


func equip(item: EquipmentResource) -> void:

    if item == null:
        return

    match item.equipment_type:

        EquipmentResource.EquipmentType.WEAPON:
            _replace_equipment(weapon, item)
            weapon = item

        EquipmentResource.EquipmentType.HELMET:
            _replace_equipment(helmet, item)
            helmet = item

        EquipmentResource.EquipmentType.ARMOR:
            _replace_equipment(armor, item)
            armor = item

        EquipmentResource.EquipmentType.GLOVES:
            _replace_equipment(gloves, item)
            gloves = item

        EquipmentResource.EquipmentType.BOOTS:
            _replace_equipment(boots, item)
            boots = item

        EquipmentResource.EquipmentType.RING:
            _replace_equipment(ring, item)
            ring = item

        EquipmentResource.EquipmentType.NECKLACE:
            _replace_equipment(necklace, item)
            necklace = item

    stat_component.equip(item)

    equipment_changed.emit()


func unequip(type: EquipmentResource.EquipmentType) -> void:

    var item: EquipmentResource = null

    match type:

        EquipmentResource.EquipmentType.WEAPON:
            item = weapon
            weapon = null

        EquipmentResource.EquipmentType.HELMET:
            item = helmet
            helmet = null

        EquipmentResource.EquipmentType.ARMOR:
            item = armor
            armor = null

        EquipmentResource.EquipmentType.GLOVES:
            item = gloves
            gloves = null

        EquipmentResource.EquipmentType.BOOTS:
            item = boots
            boots = null

        EquipmentResource.EquipmentType.RING:
            item = ring
            ring = null

        EquipmentResource.EquipmentType.NECKLACE:
            item = necklace
            necklace = null

    if item:

        stat_component.unequip(item)

    equipment_changed.emit()


func get_equipped(type: EquipmentResource.EquipmentType) -> EquipmentResource:

    match type:

        EquipmentResource.EquipmentType.WEAPON:
            return weapon

        EquipmentResource.EquipmentType.HELMET:
            return helmet

        EquipmentResource.EquipmentType.ARMOR:
            return armor

        EquipmentResource.EquipmentType.GLOVES:
            return gloves

        EquipmentResource.EquipmentType.BOOTS:
            return boots

        EquipmentResource.EquipmentType.RING:
            return ring

        EquipmentResource.EquipmentType.NECKLACE:
            return necklace

    return null


func _replace_equipment(old_item: EquipmentResource, new_item: EquipmentResource) -> void:

    if old_item != null:

        stat_component.unequip(old_item)
