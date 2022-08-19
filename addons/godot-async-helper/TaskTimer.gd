# TaskTimer.gd
# ユニット化前のタイミング生成に関する処理を含むシングルトン

extends Node

#-------------------------------------------------------------------------------
# シグナル
#-------------------------------------------------------------------------------

# メインループがアイドルになると発火します
signal idle_frame

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# 現在のゲームタイム
var time: float setget , _get_time
# 現在のゲームタイム (ミリ秒)
var time_msec: int setget , _get_time_msec
# 現在のゲームタイム (マイクロ秒)
var time_usec: int setget , _get_time_usec

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 指定したタイムアウトが経過するまで待機します (非ユニット)
func wait(timeout: float) -> GDScriptFunctionState:
	return _wait(timeout)

# メインループがアイドルになるまで待機します (非ユニット)
func wait_idle_frame() -> GDScriptFunctionState:
	return _wait_idle_frame()

#-------------------------------------------------------------------------------

func _get_time() -> float:
	return OS.get_ticks_msec() / 1000.0

func _get_time_msec() -> int:
	return OS.get_ticks_msec()

func _get_time_usec() -> int:
	return OS.get_ticks_usec()

onready var _tree := .get_tree()

func _ready() -> void:
	_tree.connect("idle_frame", self, "_on_idle_frame")

func _wait(timeout: float):
	yield(_tree.create_timer(timeout), "timeout")

func _wait_idle_frame():
	yield(_tree, "idle_frame")

func _on_idle_frame() -> void:
	.emit_signal("idle_frame")
