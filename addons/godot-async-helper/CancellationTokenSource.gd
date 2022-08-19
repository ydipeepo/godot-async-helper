# CancellationTokenSource.gd
# 待機ユニットを外部から中断させるために使用されるトークンファクトリ

class_name CancellationTokenSource extends CancellationTokenSourceBase

#-------------------------------------------------------------------------------
# 定数
#-------------------------------------------------------------------------------

# cancel_after() が対応するシグナル引数の最大数
const MAX_SIGNAL_DISCARD_ARGS := 5

#-------------------------------------------------------------------------------
# プロパティ
#-------------------------------------------------------------------------------

# キャンセルトークン
var token: CancellationToken setget , _get_token
# キャンセルトークンソース名 (デバッグ用)
var source_name: String setget , _get_source_name
# キャンセルが要求されたかどうか
var cancel_requested: bool setget , _get_cancel_requested

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# このソースにより作成されたすべてのトークンをキャンセルされた状態に変更します
func cancel() -> void:
	if not _cancel_requested:
		_cancel_requested = true
		.emit_signal("canceled")

# 指定したシグナルに継続してキャンセルされるようシグナルを接続します
func cancel_after(
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

func _get_source_name() -> String:
	return _source_name

func _get_token() -> CancellationToken:
	return CancellationToken.new(self, _cancel_requested)

func _get_cancel_requested() -> bool:
	return _cancel_requested

var _source_name: String
var _cancel_requested := false

func _init(source_name = null) -> void:
	assert(source_name == null or source_name is String)
	if source_name == null:
		source_name = "Cancel #%d" % .get_instance_id()
	_source_name = source_name

func _on_completed_0() -> void:
	cancel()

func _on_completed_1(arg1) -> void:
	cancel()

func _on_completed_2(arg1, arg2) -> void:
	cancel()

func _on_completed_3(arg1, arg2, arg3) -> void:
	cancel()

func _on_completed_4(arg1, arg2, arg3, arg4) -> void:
	cancel()

func _on_completed_5(arg1, arg2, arg3, arg4, arg5) -> void:
	cancel()
