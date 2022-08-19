# TaskUnit.gd
# 待機ユニットを表す抽象クラス
#
# アドオン外部に向けたインターフェイスですので、
# 実装する場合は TaskUnitBase を継承してください。

class_name TaskUnit

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# このユニットが完了しているかどうかを返します
func has_completed() -> bool:
	#
	# NOTE:
	# 継承先で、完了とみなした直後から常に true を返すよう実装する必要があります。
	#

	return true

# このユニットに関連付けられたシグナルが完了 (発火) した回数を返します
func get_completed_count() -> int:
	#
	# NOTE:
	# 継承先で、ユニットに関連付けられたシグナルが完了した回数を
	# 返すよう実装する必要があります。
	#

	return 0

# このユニットを待機します
func wait() -> GDScriptFunctionState:
	#
	# NOTE:
	# 継承先で、ユニットに関連付けられたシグナルを待機もしくは
	# アイドルを待機するよう実装する必要があります。
	#

	return TaskTimer.wait_idle_frame()

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: UNUSED_SIGNAL
