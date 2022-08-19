# TaskUnitBase.gd
# 待機ユニットとなる抽象クラス

class_name TaskUnitBase extends TaskUnit

#-------------------------------------------------------------------------------
# 定数
#-------------------------------------------------------------------------------

# register() が対応するシグナル引数の最大数
const MAX_SIGNAL_DISCARD_ARGS := 5

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# このユニットに関連付けられたシグナルが完了 (発火) した回数を返します
func get_completed_count() -> int:
	return _num_completed

# このユニットを待機します
func wait() -> GDScriptFunctionState:
	return .wait() if has_completed() else _wait_core()

# このユニットにシグナルを接続します
func register(
	object,
	signal_name := "completed",
	signal_discard_args := 0) -> bool:

	assert(signal_discard_args <= MAX_SIGNAL_DISCARD_ARGS, "Too many signal arguments.")

	if is_instance_valid(object) and not object.is_queued_for_deletion():
		object.connect(
			signal_name,
			self,
			"_on_completed_%d" % signal_discard_args,
			[],
			CONNECT_ONESHOT)
		return true

	return false

#-------------------------------------------------------------------------------

signal _completed_core

var _num_completed := 0

func _wait_core():
	yield(self, "_completed_core")

func _on_completed() -> void:
	if has_completed():
		.emit_signal("_completed_core")

func _on_completed_0() -> void:
	_num_completed += 1
	_on_completed()

func _on_completed_1(arg1) -> void:
	_num_completed += 1
	_on_completed()

func _on_completed_2(arg1, arg2) -> void:
	_num_completed += 1
	_on_completed()

func _on_completed_3(arg1, arg2, arg3) -> void:
	_num_completed += 1
	_on_completed()

func _on_completed_4(arg1, arg2, arg3, arg4) -> void:
	_num_completed += 1
	_on_completed()

func _on_completed_5(arg1, arg2, arg3, arg4, arg5) -> void:
	_num_completed += 1
	_on_completed()

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: UNUSED_SIGNAL
