extends Resource
class_name AttackResource

@export_group("기본")

@export var attack_name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D

@export_group("데미지")

@export var power: float = 1.0
@export var use_magic_attack: bool = false
@export var ignore_defense: bool = false

@export_group("자원")

@export var mp_cost: int = 0
@export var cooldown: float = 0.5

## Hitbox
@export_group("Hitbox")

@export var hitbox_scene: PackedScene

@export var offset := Vector3.ZERO
@export var range := 1.2
@export var rotation := Vector3.ZERO
@export var scale := Vector3.ONE

# 추가
@export var destroy_on_hit := true
@export var duration := 0.2

@export_group("투사체")

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 10.0

@export_group("효과")

@export var knockback: float = 0.0
@export var critical_enabled: bool = true

@export_group("Combo")

@export var next_combo: AttackResource

@export var combo_reset_time := 0.8

## 애니메이션 진행률(0~1)
@export_range(0.0, 1.0)
var combo_window_start := 0.7

@export_range(0.0, 1.0)
var combo_window_end := 1.0

@export_group("다중 공격")

@export var hit_count: int = 1
@export var hit_interval: float = 0.0

enum AttackType {
    MELEE,
    PROJECTILE,
    AREA
}

@export var attack_type := AttackType.MELEE

@export_group("애니메이션")

@export var animation_name: StringName
@export var animation_speed: float = 1.0

func has_combo() -> bool:
    return next_combo != null
