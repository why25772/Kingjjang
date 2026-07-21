extends CanvasLayer

@onready var level_label: Label = $HUD/LevelLabel
@onready var exp_bar: TextureProgressBar = $HUD/ExpBar
@onready var exp_label: Label = $HUD/ExpLabel

@onready var player: Player = $"../../Player"

func _ready():

    player.stat.exp_changed.connect(refresh)
    player.stat.level_up_signal.connect(refresh)

    refresh()

func refresh(_a = null, _b = null):

    level_label.text = "Lv.%d" % player.stat.level

    exp_bar.max_value = player.stat.max_exp
    exp_bar.value = player.stat.exp

    exp_label.text = "%d / %d" % [
        player.stat.exp,
        player.stat.max_exp
    ]
