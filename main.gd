
extends Node

var player
var skill_tree
var skill_tree_ui


func _ready():

    player = $Player
    skill_tree = $SkillTreeManager
    skill_tree_ui = $CanvasLayer/SkillTreeUI

    skill_tree.initialize(player)

    skill_tree_ui.visible = false

func toggle_skill_tree():

    skill_tree_ui.visible = !skill_tree_ui.visible


func _on_skill_button_pressed():

    print(skill_tree_ui)

    skill_tree_ui.visible = true

func _on_attack_button_pressed():
    $Player.attack()
