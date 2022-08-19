# CancellationTokenSource.gd
# 待機ユニットを外部から中断させるために使用されるトークン

class_name CancellationToken

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# キャンセルトークンソース名 (デバッグ用)
var source_name: String setget , _get_source_name
# キャンセルトークン名 (デバッグ用, "トークンソース名+トークンインスタンス識別子")
var name: String setget , _get_name
# キャンセルが要求されたかどうか
var cancel_requested: bool setget , _get_cancel_requested

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# このトークンを作成したソースがキャンセルされるまで待機します
func wait() -> GDScriptFunctionState:
	return TaskTimer.wait_idle_frame() if _cancel_requested else _wait_core()

#---------------------------------------------------------------------------

func _get_source_name() -> String:
	return _source.name

func _get_name() -> String:
	return "%s-%d" % [_source.source_name, .get_instance_id()]

func _get_cancel_requested() -> bool:
	return _cancel_requested

signal _completed

var _source: CancellationTokenSourceBase
var _cancel_requested: bool

func _init(source: CancellationTokenSourceBase, cancel_requested: bool) -> void:
	assert(source != null)
	_source = source
	_cancel_requested = cancel_requested
	if not _cancel_requested:
		_source.connect("canceled", self, "_on_source_canceled", [], CONNECT_ONESHOT)

func _wait_core():
	yield(self, "_completed")

func _on_source_canceled() -> void:
	assert(not _cancel_requested)
	_cancel_requested = true
	.emit_signal("_completed")

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: SHADOWED_VARIABLE
# warning-ignore-all: UNUSED_SIGNAL
