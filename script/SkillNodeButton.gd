extends TextureButton

class_name SkillNodeButton
enum NodeState {
    LOCKED,
    AVAILABLE,
    LEVELED,
    LEARNED
}
signal skill_pressed(skill : SkillNode)

var skill : SkillNode

@onready var name_label = $Name
@onready var level_label: Label = $LevelLabel
func setup(skill_data : SkillNode):

    skill = skill_data

    print("setup :", skill.title)

    if name_label != null:
        name_label.text = skill.title
    
func _ready():

    pressed.connect(_on_pressed)
    
func _on_pressed():

    skill_pressed.emit(skill)
func set_state(state : NodeState):

    match state:

        NodeState.LOCKED:
            modulate = Color(0.45,0.45,0.45)

        NodeState.AVAILABLE:
            modulate = Color(1,1,1)

        NodeState.LEARNED:
            modulate = Color(0.3,1,0.3)

func set_level(current_level: int, max_level: int):

    level_label.text = "%d/%d" % [current_level, max_level]
