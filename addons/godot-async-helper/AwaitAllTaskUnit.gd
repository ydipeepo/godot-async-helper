# AwaitAllTaskUnit.gd
# Task.wait_all() で使用される待機ユニット

class_name AwaitAllTaskUnit extends AwaitTaskUnitBase

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# このユニットが完了しているかどうかを返します
func has_completed() -> bool:
	return get_completed_count() >= get_registered_count()
