extends Control

var skill_tree
var skill_ui


func redraw():
    queue_redraw()


func _draw():

    if skill_tree == null:
        return

    if skill_ui == null:
        return

    for parent in skill_tree.children_map.keys():

        if !skill_ui.buttons.has(parent):
            continue

        var parent_button : SkillNodeButton = skill_ui.buttons[parent]

        var start = parent_button.position + parent_button.size * 0.5

        for child in skill_tree.children_map[parent]:

            if !skill_ui.buttons.has(child):
                continue

            var child_button : SkillNodeButton = skill_ui.buttons[child]

            var end = child_button.position + child_button.size * 0.5

            draw_line(
                start,
                end,
                Color.WHITE,
                4.0,
                true
            )
