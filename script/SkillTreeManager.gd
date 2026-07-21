extends Node
class_name SkillTreeManager
signal skill_learned(skill_id:String)
# 모든 스킬을 저장
var skills: Dictionary = {}
var children_map : Dictionary = {}
var depth_map : Dictionary = {}
var unlocked_skills: Dictionary = {}
var player : Player
var layer_map : Dictionary = {}
var width_map : Dictionary = {}
var position_map : Dictionary = {}
# 스킬이 들어있는 폴더
const SKILL_PATH := "res://resources/skills"
enum UnlockResult {
    OK,
    SKILL_NOT_FOUND,
    MAX_LEVEL,
    PLAYER_LEVEL,
    PARENT,
    PARENT_LEVEL,
    SKILL_POINT
}
func _ready():
    load_skills()
    build_children()
    build_width()
    build_position()
    print(position_map)

func load_skills():
    skills.clear()

    var dir := DirAccess.open(SKILL_PATH)

    if dir == null:
        push_error("스킬 폴더를 찾을 수 없습니다.")
        return

    dir.list_dir_begin()
    
    while true:
        var file_name = dir.get_next()

        if file_name == "":
            break

        if dir.current_is_dir():
            continue

        if file_name.get_extension() != "tres":
            continue

        var skill: SkillNode = load(SKILL_PATH + "/" + file_name)

        if skill == null:
            continue

        skills[skill.id] = skill

        print("스킬 로드 :", skill.id)

    dir.list_dir_end()
    build_children()

    build_width()

    build_position()
func can_unlock(skill_id: String) -> bool:
    return get_unlock_result(skill_id) == UnlockResult.OK
    
func get_unlock_result(skill_id: String) -> UnlockResult:

    if !skills.has(skill_id):
        return UnlockResult.SKILL_NOT_FOUND

    var skill: SkillNode = skills[skill_id]

    var current_level: int = int(unlocked_skills.get(skill_id, 0))

    # 최대 레벨 확인
    if current_level >= skill.max_level:
        return UnlockResult.MAX_LEVEL

    # 플레이어 레벨 확인
    if player.stat.level < skill.required_player_level:
        return UnlockResult.PLAYER_LEVEL

    # 시작 노드
    if skill.parents.is_empty():

        if player.stat.skill_points < skill.cost:
            return UnlockResult.SKILL_POINT

        return UnlockResult.OK

    # 부모 노드 검사
    for parent in skill.parents:

        if !unlocked_skills.has(parent):
            return UnlockResult.PARENT

        var parent_level: int = int(unlocked_skills.get(parent, 0))

        if parent_level < skill.required_parent_level:
            return UnlockResult.PARENT_LEVEL

    # SP 확인
    if player.stat.skill_points < skill.cost:
        return UnlockResult.SKILL_POINT

    return UnlockResult.OK
func unlock(skill_id: String) -> bool:

    if !can_unlock(skill_id):
        print("해금 불가 :", skill_id)
        return false

    if unlocked_skills.has(skill_id):
        print("이미 해금 :", skill_id)
        return false

    unlocked_skills[skill_id] = true

    print("해금 성공 :", skill_id)

    return true
func learn(skill_id: String):

    if !can_unlock(skill_id):
        return

    if !skills.has(skill_id):
        return

    var skill: SkillNode = skills[skill_id]

    var current_level: int = int(unlocked_skills.get(skill_id, 0))

    if current_level >= skill.max_level:
        print("이미 최대 레벨입니다.")
        return

    if player.stat.skill_points < skill.cost:
        print("스킬 포인트 부족")
        return

    player.stat.skill_points -= skill.cost

    unlocked_skills[skill_id] = current_level + 1

    player.learn_skill(skill)

    skill_learned.emit(skill_id)

    print(skill.title, " Lv.", current_level + 1)
func build_children():

    children_map.clear()

    for skill in skills.values():

        for parent in skill.parents:

            if !children_map.has(parent):
                children_map[parent] = []

            children_map[parent].append(skill.id)

    print("==== Children ====")

    for id in children_map.keys():
        print(id," -> ",children_map[id])
        
func build_depth():

    depth_map.clear()

    var queue:Array = []

    # 부모가 없는 노드를 시작점으로 사용
    for skill in skills.values():

        if skill.parents.is_empty():

            depth_map[skill.id] = 0
            queue.append(skill.id)

    while !queue.is_empty():

        var current = queue.pop_front()

        var current_depth = depth_map[current]

        if children_map.has(current):

            for child in children_map[current]:

                depth_map[child] = current_depth + 1
                queue.append(child)

    print("===== Depth =====")

    for id in depth_map.keys():

        print(id, " : ", depth_map[id])
        build_layers()
        
func build_layers():

    layer_map.clear()

    for id in depth_map.keys():

        var depth = depth_map[id]

        if !layer_map.has(depth):
            layer_map[depth] = []

        layer_map[depth].append(id)

    print("===== Layer =====")

    for layer in layer_map.keys():

        print(layer," : ",layer_map[layer])

func get_root_nodes():

    var roots := []

    for skill in skills.values():

        if skill.parents.is_empty():
            roots.append(skill.id)

    return roots
    
func build_width():

    width_map.clear()

    for root in get_root_nodes():
        calculate_width(root)
        
func calculate_width(id:String) -> int:

    if !children_map.has(id):

        width_map[id] = 1
        return 1

    var width := 0

    for child in children_map[id]:

        width += calculate_width(child)

    width = max(width,1)

    width_map[id] = width

    return width

func build_position():

    position_map.clear()

    var start_y := 0.0

    for root in get_root_nodes():

        calculate_position(root, 0, start_y)

        start_y += width_map[root] * 180
    
    print("===== Position =====")

    for id in position_map.keys():
        print(id, " : ", position_map[id])

func calculate_position(id:String, depth:int, start_y:float):

    var width = width_map[id]

    var center_y = start_y + (width - 1) * 90

    position_map[id] = Vector2(
        100 + depth * 350,
        100 + center_y
    )

    if !children_map.has(id):
        return

    var child_y = start_y

    for child in children_map[id]:

        calculate_position(
            child,
            depth + 1,
            child_y
        )

        child_y += width_map[child] * 180
func initialize(target_player):

    player = target_player
