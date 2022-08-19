# Task.gd
# ユニット操作に関する処理を含むこのアドオンの中心となるシングルトン

extends Node

#-------------------------------------------------------------------------------
# メソッド
#-------------------------------------------------------------------------------

# 完了済みのユニットを返します
func empty() -> TaskUnit:
	return EmptyTaskUnit.new()

# 指定したシグナルが完了するまで待機するユニットを返します
func defer(
	object,
	signal_name := "completed",
	signal_discard_args := 0,
	cancel_token_or_timeout = null) -> TaskUnit:

	assert(name == null or name is String)

	var unit: DeferTaskUnit
	if cancel_token_or_timeout is CancellationToken:
		if cancel_token_or_timeout.cancel_requested:
			return empty()
		unit = DeferTaskUnit.new()
		unit.register(object, signal_name, signal_discard_args)
		unit.register(cancel_token_or_timeout.wait())
	elif cancel_token_or_timeout is float:
		unit = DeferTaskUnit.new()
		unit.register(object, signal_name, signal_discard_args)
		unit.register(wait(cancel_token_or_timeout))
	else:
		assert(cancel_token_or_timeout == null)
		unit = DeferTaskUnit.new()
		unit.register(object, signal_name, signal_discard_args)
	return unit

# 指定したタイムアウトが経過するまで待機するユニットを返します
func delay(timeout: float, cancel_token = null) -> TaskUnit:
	var unit := DeferTaskUnit.new()
	unit.register(TaskTimer.wait(timeout))
	if cancel_token != null:
		assert(cancel_token is CancellationToken)
		unit.register(cancel_token.wait())
	return unit

# 指定したタイムアウトが経過するまで待機するユニットを返します
func delay_msec(timeout: float, cancel_token = null) -> TaskUnit:
	return delay(timeout / 1_000.0, cancel_token)

# 指定したタイムアウトが経過するまで待機するユニットを返します
func delay_usec(timeout: float, cancel_token = null) -> TaskUnit:
	return delay(timeout / 1_000_000.0, cancel_token)

# 指定したシグナル定義のうちどれか一つが完了するまで待機するユニットを返します
func when_any(signal_specs: Array, cancel_token_or_timeout = null) -> TaskUnit:
	assert(len(signal_specs) > 0, "Have to specify one or more signal specs.")

	var unit: AwaitTaskUnitBase
	if cancel_token_or_timeout is CancellationToken:
		if cancel_token_or_timeout.cancel_requested:
			return empty()
		unit = AwaitAnyTaskUnit.new()
		unit.register_all(signal_specs)
		unit.register(cancel_token_or_timeout.wait())
	elif cancel_token_or_timeout is float:
		unit = AwaitAnyTaskUnit.new()
		unit.register_all(signal_specs)
		unit.register(wait(cancel_token_or_timeout))
	else:
		assert(cancel_token_or_timeout == null)
		unit = AwaitAnyTaskUnit.new()
		unit.register_all(signal_specs)
	return unit

# 指定したシグナル定義がすべて完了するまで待機するユニットを返します
func when_all(signal_specs: Array, cancel_token_or_timeout = null) -> TaskUnit:
	assert(len(signal_specs) > 0, "Have to specify one or more signal specs.")

	var unit: AwaitTaskUnitBase
	if cancel_token_or_timeout is CancellationToken:
		if cancel_token_or_timeout.cancel_requested:
			return empty()
		var parent_unit := AwaitAllTaskUnit.new()
		parent_unit.register_all(signal_specs)
		unit = AwaitAnyTaskUnit.new()
		unit.register(parent_unit.wait())
		unit.register(cancel_token_or_timeout.wait())
	elif cancel_token_or_timeout is float:
		var parent_unit := AwaitAllTaskUnit.new()
		parent_unit.register_all(signal_specs)
		unit = AwaitAnyTaskUnit.new()
		unit.register(parent_unit.wait())
		unit.register(wait(cancel_token_or_timeout))
	else:
		assert(cancel_token_or_timeout == null)
		unit = AwaitAllTaskUnit.new()
		unit.register_all(signal_specs)
	return unit

# 指定したタイムアウトが経過するまで待機します
func wait(timeout = null, cancel_token = null) -> GDScriptFunctionState:
	assert(timeout == null or timeout is float)
	var unit: TaskUnit = empty() if timeout == null else delay(timeout, cancel_token)
	return unit.wait()

# 指定したシグナル定義のうちどれか一つが完了するまで待機します
func wait_any(signal_specs: Array, cancel_token_or_timeout = null) -> GDScriptFunctionState:
	return when_any(signal_specs, cancel_token_or_timeout).wait()

# 指定したシグナル定義がすべて完了するまで待機します
func wait_all(signal_specs: Array, cancel_token_or_timeout = null) -> GDScriptFunctionState:
	return when_all(signal_specs, cancel_token_or_timeout).wait()

# warning-ignore-all: RETURN_VALUE_DISCARDED
