extends CharacterBody3D

@onready var stat: StatComponent = $StatComponent
@onready var health: HealthComponent = $HealthComponent

@export var move_speed := 3.0
@export var exp_reward := 5
@export var xp_orb_scene: PackedScene

var target: Node3D


func _ready() -> void:
    health.died.connect(_on_died)


func _physics_process(_delta: float) -> void:

    if target == null:
        return

    var direction := global_position.direction_to(target.global_position)

    velocity.x = direction.x * move_speed
    velocity.z = direction.z * move_speed

    move_and_slide()


func _on_died() -> void:

    var death_position := global_position

    if xp_orb_scene != null:
        var orb = xp_orb_scene.instantiate()

        get_parent().add_child(orb)

        orb.exp_amount = exp_reward
        orb.global_position = death_position

    queue_free()
