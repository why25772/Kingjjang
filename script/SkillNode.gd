extends Resource
class_name SkillNode

@export var id: String
@export var title: String
@export_multiline var description: String

# 부모 스킬
@export var parents: Array[String] = []

# 부모 스킬 필요 레벨
@export var required_parent_level := 1

# 플레이어 필요 레벨
@export var required_player_level := 1

# 비용
@export var cost := 1

# 최대 레벨
@export var max_level := 1

# ===== 스탯 효과 =====

@export var str := 0
@export var dex := 0
@export var intelligence := 0
@export var luk := 0

@export var max_hp := 0
@export var max_mp := 0

@export var hp_regen := 0
@export var mp_regen := 0

@export var attack := 0
@export var magic_attack := 0

@export var defense := 0
@export var magic_defense := 0

@export var attack_speed := 0.0
@export var move_speed := 0.0

@export var crit_rate := 0.0
@export var crit_damage := 0.0

@export var final_damage := 0.0

# 스킬 해금
@export var unlock_skill := ""

# UI
@export var icon: Texture2D
