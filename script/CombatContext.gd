extends RefCounted

class_name CombatContext


var attacker: Node
var target: Node

var attack_resource: AttackResource

var base_damage: int = 0
var final_damage: int = 0

var critical: bool = false
var critical_rate: float = 0.0
var critical_damage: float = 1.5

var damage_type: StringName = &"Physical"

var knockback: float = 0.0

var can_evade: bool = true
var can_block: bool = true

var tags: Array[StringName] = []
