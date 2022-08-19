# Plugin.gd
# プラグイン構成

tool
extends EditorPlugin

#-------------------------------------------------------------------------------

func _enter_tree() -> void:
	.add_autoload_singleton("TaskTimer", "res://addons/godot-async-helper/TaskTimer.gd")
	.add_autoload_singleton("Task", "res://addons/godot-async-helper/Task.gd")

func _exit_tree() -> void:
	.remove_autoload_singleton("Task")
	.remove_autoload_singleton("TaskTimer")
