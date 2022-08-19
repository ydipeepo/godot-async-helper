# AwaitAnyTaskUnit.gd
# Task.wait_any() で使用される待機ユニット

class_name AwaitAnyTaskUnit extends AwaitTaskUnitBase

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# このユニットが完了しているかどうかを返します
func has_completed() -> bool:
	return get_completed_count() >= 1 and get_registered_count() >= 1
