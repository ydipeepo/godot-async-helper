# AwaitTaskUnitBase.gd
# 複数のシグナル接続に対応した待機ユニットの抽象クラス

class_name AwaitTaskUnitBase extends TaskUnitBase

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# このユニットに関連付けられたシグナル数を返します
func get_registered_count() -> int:
	return _num_registered

# このユニットにシグナルを接続します
func register(
	object,
	signal_name := "completed",
	signal_discard_args := 0) -> bool:

	if .register(object, signal_name, signal_discard_args):
		_num_registered += 1
		return true

	return false

# このユニットに signal_specs で定義されたシグナルを一括して接続します
func register_all(signal_specs: Array) -> void:
	for signal_spec in signal_specs:
		var registered := false
		match signal_spec:
			[var object, var signal_name, var signal_discard_args]:
				registered = register(object, signal_name, signal_discard_args)
			[var object, var signal_name]:
				registered = register(object, signal_name)
			var object:
				registered = register(object)
		assert(registered, "Failed to register spec: %s" % str(signal_spec))

#-------------------------------------------------------------------------------

var _num_registered := 0

# warning-ignore-all: RETURN_VALUE_DISCARDED
