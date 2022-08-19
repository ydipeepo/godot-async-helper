# CancellationTokenSourceBase.gd
# CancellationTokenSource の基底となるクラス
#
# canceled シグナル定義を分離するためだけに存在します。
# この定義は内部用ですので直接使うことはありません。

class_name CancellationTokenSourceBase

#-------------------------------------------------------------------------------
# シグナル
#-------------------------------------------------------------------------------

# このソースがキャンセルされたとき発火します
signal canceled

# warning-ignore-all: UNUSED_SIGNAL
