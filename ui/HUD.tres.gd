extends CanvasLayer

@export var player: Player

@onready var hp_label: Label = $MarginContainer/VBoxContainer/HPLabel
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var exp_bar: ProgressBar = $MarginContainer/VBoxContainer/ExpBar


func _process(_delta):

    if player == null:
        return

    var stat = player.stat

    hp_label.text = "HP : %d / %d" % [
        player.health.get_hp(),
        player.health.get_max_hp()
    ]

    level_label.text = "Lv. %d" % stat.level

    exp_bar.max_value = stat.max_exp
    exp_bar.value = stat.exp
