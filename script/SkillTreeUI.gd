extends Control

var buttons: Dictionary = {}
var selected_skill_id = ""

@onready var skill_point_label = $TopBar/SkillPointLabel
@export var node_scene: PackedScene

@onready var line_layer = $CameraContainer/LineLayer
@onready var node_container = $CameraContainer/NodeContainer
@onready var camera_container = $CameraContainer
@onready var skill_tree = $"../../SkillTreeManager"
@onready var player = $"../../Player"

@onready var info_panel = $InfoPanel

@onready var skill_name_label = $InfoPanel/SkillNameLabel
@onready var skill_level_label = $InfoPanel/SkillLevelLabel
@onready var requirement_label = $InfoPanel/RequirementLabel
@onready var skill_description_label = $InfoPanel/SkillDescriptionLabel
@onready var skill_cost_label = $InfoPanel/SkillCostLabel
@onready var learn_button = $InfoPanel/LearnButton

var dragging := false
var last_touch := Vector2.ZERO

var touches := {}

var last_drag_pos := Vector2.ZERO
var last_pinch_distance := 0.0

const MIN_ZOOM := 0.6
const MAX_ZOOM := 2.0
const ZOOM_SPEED := 0.003

var drag_velocity := Vector2.ZERO

const DRAG_FRICTION := 0.92
const MIN_VELOCITY := 3.0

var map_min := Vector2.ZERO
var map_max := Vector2.ZERO

const CAMERA_MARGIN := 250.0
func _ready():

    create_nodes()
    calculate_camera_bounds()
    line_layer.skill_tree = skill_tree
    line_layer.skill_ui = self

    line_layer.redraw()

    refresh()
    info_panel.visible = false
    update_skill_point()

func create_nodes():

    buttons.clear()

    for id in skill_tree.position_map.keys():

        var skill = skill_tree.skills[id]

        var node: SkillNodeButton = node_scene.instantiate()

        node_container.add_child(node)

        node.setup(skill)

        # Control의 크기가 적용될 때까지 한 프레임 기다림
        await get_tree().process_frame

        node.position = skill_tree.position_map[id] - node.size * 0.5

        node.skill_pressed.connect(_on_skill_pressed)

        buttons[id] = node

        print(
            "생성 : ",
            skill.title,
            " / 위치 = ",
            node.position,
            " / 크기 = ",
            node.size
        )


func _on_skill_pressed(skill: SkillNode):

    show_skill_info(skill.id)

func refresh():

    for id in buttons.keys():

        var button: SkillNodeButton = buttons[id]
        var skill: SkillNode = skill_tree.skills[id]

        var current_level: int = int(skill_tree.unlocked_skills.get(id, 0))
        var result = skill_tree.get_unlock_result(id)
        button.set_level(current_level, skill.max_level)
        # 만렙
        if current_level >= skill.max_level:

            button.set_state(
                SkillNodeButton.NodeState.LEARNED
            )

        # 이미 한 번 이상 찍은 스킬 (만렙 아님)
        elif current_level > 0:

            button.set_state(
                SkillNodeButton.NodeState.AVAILABLE
            )

        # 아직 안 찍었지만 찍을 수 있는 상태
        elif result == SkillTreeManager.UnlockResult.OK \
        or result == SkillTreeManager.UnlockResult.SKILL_POINT:

            button.set_state(
                SkillNodeButton.NodeState.AVAILABLE
            )

        # 아직 잠겨있는 스킬
        else:

            button.set_state(
                SkillNodeButton.NodeState.LOCKED
            )
            
func _input(event):

    # 손가락 터치 시작/끝
    if event is InputEventScreenTouch:

        if event.pressed:
            touches[event.index] = event.position
        else:
            touches.erase(event.index)

            last_pinch_distance = 0.0


    # 손가락 이동
    elif event is InputEventScreenDrag:

        touches[event.index] = event.position


        # ----------------------------
        # 한 손가락 : 드래그
        # ----------------------------

        if touches.size() == 1:

            camera_container.position += event.relative
            drag_velocity = event.relative

        # ----------------------------
        # 두 손가락 : 핀치 줌
        # ----------------------------

        elif touches.size() == 2:

            var keys = touches.keys()

            var p1 = touches[keys[0]]
            var p2 = touches[keys[1]]

            var distance = p1.distance_to(p2)

            if last_pinch_distance > 0.0:

                var diff = distance - last_pinch_distance

                var zoom = camera_container.scale.x

                zoom += diff * ZOOM_SPEED

                zoom = clamp(
                    zoom,
                    MIN_ZOOM,
                    MAX_ZOOM
                )

                camera_container.scale = Vector2(zoom, zoom)

            last_pinch_distance = distance

func _process(delta):

    if touches.size() == 0:

        if drag_velocity.length() > MIN_VELOCITY:

            camera_container.position += drag_velocity

            drag_velocity *= pow(DRAG_FRICTION, delta * 60.0)

        else:

            drag_velocity = Vector2.ZERO


    var zoom = camera_container.scale.x


    var view = get_viewport_rect().size


    var min_pos = Vector2(
        view.x - map_max.x * zoom,
        view.y - map_max.y * zoom
    )

    var max_pos = Vector2(
        -map_min.x * zoom,
        -map_min.y * zoom
    )


    camera_container.position.x = clamp(
        camera_container.position.x,
        min_pos.x,
        max_pos.x
    )

    camera_container.position.y = clamp(
        camera_container.position.y,
        min_pos.y,
        max_pos.y
    )
func calculate_camera_bounds():

    if skill_tree.position_map.is_empty():
        return

    var first = true

    for pos in skill_tree.position_map.values():

        if first:

            map_min = pos
            map_max = pos
            first = false

        else:

            map_min.x = min(map_min.x, pos.x)
            map_min.y = min(map_min.y, pos.y)

            map_max.x = max(map_max.x, pos.x)
            map_max.y = max(map_max.y, pos.y)

    map_min -= Vector2(CAMERA_MARGIN, CAMERA_MARGIN)
    map_max += Vector2(CAMERA_MARGIN, CAMERA_MARGIN)

    print(map_min)
    print(map_max)


func _on_close_button_pressed():
    visible = false
    
func open():
    visible = true

func close():
    visible = false
func show_skill_info(skill_id: String):

    selected_skill_id = skill_id

    var skill = skill_tree.skills[skill_id]

    var current_level: int = int(skill_tree.unlocked_skills.get(skill_id, 0))
    var result = skill_tree.get_unlock_result(skill_id)

    skill_name_label.text = skill.title
    skill_level_label.text = "레벨 : %d / %d" % [current_level, skill.max_level]
    skill_description_label.text = skill.description
    skill_cost_label.text = "필요 SP : %d" % skill.cost

    if current_level >= skill.max_level:

        requirement_label.text = "최대 레벨"

    else:

        match result:

            SkillTreeManager.UnlockResult.OK:
                requirement_label.text = "습득 가능"

            SkillTreeManager.UnlockResult.SKILL_POINT:
                requirement_label.text = "스킬 포인트 부족"

            SkillTreeManager.UnlockResult.PLAYER_LEVEL:
                requirement_label.text = "플레이어 Lv.%d 필요" % skill.required_player_level

            SkillTreeManager.UnlockResult.PARENT:
                requirement_label.text = "선행 스킬 필요"

            SkillTreeManager.UnlockResult.PARENT_LEVEL:
                requirement_label.text = "선행 스킬 Lv.%d 필요" % skill.required_parent_level

            _:
                requirement_label.text = ""

       # Learn 버튼 상태
    if current_level >= skill.max_level:

        learn_button.disabled = true
        learn_button.text = "MAX"

    elif result == SkillTreeManager.UnlockResult.OK:

        learn_button.disabled = false
        learn_button.text = "습득"

    elif result == SkillTreeManager.UnlockResult.SKILL_POINT:

        learn_button.disabled = true
        learn_button.text = "SP 부족"

    else:

        learn_button.disabled = true
        learn_button.text = "잠김"

    info_panel.visible = true
    
    update_skill_point()

func _on_learn_button_pressed():

    skill_tree.learn(selected_skill_id)

    refresh()

    line_layer.redraw()

    update_skill_point()

    show_skill_info(selected_skill_id)

func update_skill_point():

    skill_point_label.text = "SP : %d" % player.stat.skill_points
