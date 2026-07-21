extends CharacterBody3D
class_name Player
var is_attacking := false

@onready var health = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var stat = $StatComponent
@onready var animation: AnimationPlayer = $AnimationPlayer
@export var current_attack: AttackResource
var combo_attack: AttackResource
var combo_timer := 0.0
var combo_buffered := false
var combo_buffer_time := 0.25
var combo_window_open := false
var attack_cooldown := 0.0
var last_direction := Vector3.FORWARD

@onready var movement: MovementComponent = $MovementComponent
@onready var camera_pivot: Node3D = $CameraPivot
var shake_time := 0.0
var shake_strength := 0.0
var camera_origin := Vector3.ZERO

func _ready() -> void:
    camera_origin = camera_pivot.position
    combo_attack = current_attack
func _physics_process(delta):

    if attack_component.is_attacking():
        var anim := animation.current_animation
        if anim != "":
            var length := animation.current_animation_length
            if length > 0.0:
                var progress := animation.current_animation_position / length
                combo_window_open = progress >= combo_attack.combo_window_start \
                    and progress <= combo_attack.combo_window_end
    else:
        combo_window_open = false
    if attack_cooldown > 0.0:
        attack_cooldown -= delta
    movement.update_movement(delta)

    if combo_timer > 0.0:

        combo_timer -= delta

        if combo_timer <= 0.0:
            combo_attack = current_attack
    
    if combo_buffered:

        combo_buffer_time -= delta

        if combo_buffer_time <= 0.0:
            combo_buffered = false
            
func attack():

    if attack_component.is_attacking():
        if combo_attack.has_combo() and combo_window_open:
            combo_buffered = true
            combo_buffer_time = 0.25
        return

    if combo_attack == null:
        return

    if is_attacking:
        return

    if attack_cooldown > 0.0:
        return

    is_attacking = true

    attack_cooldown = combo_attack.cooldown / stat.attack_speed

    animation.speed_scale = combo_attack.animation_speed * stat.attack_speed

    attack_component.attack(combo_attack)

    animation.play(combo_attack.animation_name)

func add_exp(amount: int):

    print("경험치 획득 :", amount)

    stat.add_exp(amount)
func learn_skill(skill: SkillNode) -> void:

    var flat := StatModifier.ModifierType.FLAT

    if skill.str != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.STR, flat, skill.str))

    if skill.dex != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.DEX, flat, skill.dex))

    if skill.intelligence != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.INT, flat, skill.intelligence))

    if skill.luk != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.LUK, flat, skill.luk))

    if skill.max_hp != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.MAX_HP, flat, skill.max_hp))

    if skill.max_mp != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.MAX_MP, flat, skill.max_mp))

    if skill.hp_regen != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.HP_REGEN, flat, skill.hp_regen))

    if skill.mp_regen != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.MP_REGEN, flat, skill.mp_regen))

    if skill.attack != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.ATTACK, flat, skill.attack))

    if skill.magic_attack != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.MAGIC_ATTACK, flat, skill.magic_attack))

    if skill.defense != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.DEFENSE, flat, skill.defense))

    if skill.magic_defense != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.MAGIC_DEFENSE, flat, skill.magic_defense))

    if skill.attack_speed != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.ATTACK_SPEED, flat, skill.attack_speed))

    if skill.move_speed != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.MOVE_SPEED, flat, skill.move_speed))

    if skill.crit_rate != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.CRIT_RATE, flat, skill.crit_rate))

    if skill.crit_damage != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.CRIT_DAMAGE, flat, skill.crit_damage))

    if skill.final_damage != 0:
        stat.add_modifier(StatModifier.new(StatType.Type.FINAL_DAMAGE, flat, skill.final_damage))

    if skill.unlock_skill != "":
        print("스킬 해금 :", skill.unlock_skill)
    stat.refresh_stats()
    print("스킬 습득 :", skill.title)
    
func shake_camera(duration := 0.08, strength := 0.06):
    shake_time = duration
    shake_strength = strength

func attack_hit():
    attack_component.attack_hit()
func attack_end():

    is_attacking = false

    attack_component.attack_end()

    var next_attack := combo_attack.next_combo

    combo_timer = combo_attack.combo_reset_time

    if next_attack != null:
        combo_attack = next_attack
    else:
        combo_attack = current_attack

    if combo_buffered:
        combo_buffered = false
        call_deferred("attack")
