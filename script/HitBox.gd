extends Area3D

class_name Hitbox

@export var owner_node: Node

var context: CombatContext

var _hit_targets: Array[Hurtbox] = []


func activate() -> void:
    _hit_targets.clear()
    set_deferred("monitoring", true)


func deactivate() -> void:
    set_deferred("monitoring", false)


func _ready() -> void:

    monitoring = false

func _on_body_entered(_body: Node) -> void:
    pass


func _on_area_entered(area: Area3D) -> void:
    print("Area Entered")
    if context == null:
        return

    if !(area is Hurtbox):
        return

    var hurtbox := area as Hurtbox

    # 자기 자신은 공격하지 않음
    if hurtbox.get_parent() == owner_node:
        return

    # 같은 적 중복 타격 방지
    if _hit_targets.has(hurtbox):
        return

    _hit_targets.append(hurtbox)

    context.target = hurtbox

    hurtbox.receive_hit(context)

    # 한 번만 맞는 공격이면 제거
    if context.attack_resource != null:

        if context.attack_resource.destroy_on_hit:

            deactivate()
            queue_free()
