# DeferTaskUnit.gd
# Task.defer() で使用される待機ユニット

class_name DeferTaskUnit extends TaskUnitBase

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# このユニットが完了しているかどうかを返します
func has_completed() -> bool:
	return .get_completed_count() >= 1
