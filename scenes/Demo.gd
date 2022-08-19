extends Control

func _run_wait_all_timer1():
	$WaitAllTimer1.pressed = false
	yield(Task.wait(randf() * 1.5 + 0.5), "completed")
	$WaitAllTimer1.pressed = true

func _run_wait_all_timer2():
	$WaitAllTimer2.pressed = false
	yield(Task.wait(randf() * 1.5 + 0.5), "completed")
	$WaitAllTimer2.pressed = true

func _run_wait_all_timer3():
	$WaitAllTimer3.pressed = false
	yield(Task.wait(randf() * 1.5 + 0.5), "completed")
	$WaitAllTimer3.pressed = true

func _on_WaitAll_pressed():
	$WaitAll.disabled = true
	$WaitAllWithTimeout.disabled = true
	$WaitAllWithCancellation.disabled = true

	var signal_specs := [_run_wait_all_timer1(), _run_wait_all_timer2(), _run_wait_all_timer3()]
	yield(Task.wait_all(signal_specs), "completed")

	$WaitAll.disabled = false
	$WaitAllWithTimeout.disabled = false
	$WaitAllWithCancellation.disabled = false

func _on_WaitAllWithTimeout_pressed():
	$WaitAll.disabled = true
	$WaitAllWithTimeout.disabled = true
	$WaitAllWithCancellation.disabled = true

	var signal_specs := [_run_wait_all_timer1(), _run_wait_all_timer2(), _run_wait_all_timer3()]
	yield(Task.wait_all(signal_specs, 1.0), "completed")

	$WaitAll.disabled = false
	$WaitAllWithTimeout.disabled = false
	$WaitAllWithCancellation.disabled = false

func _on_WaitAllWithCancellation_pressed():
	$WaitAll.disabled = true
	$WaitAllWithTimeout.disabled = true
	$WaitAllWithCancellation.disabled = true
	$WaitAllCancel.disabled = false

	var cancel := CancellationTokenSource.new()
	cancel.cancel_after($WaitAllCancel, "pressed")
	var signal_specs := [_run_wait_all_timer1(), _run_wait_all_timer2(), _run_wait_all_timer3()]
	yield(Task.wait_all(signal_specs, cancel.token), "completed")

	$WaitAll.disabled = false
	$WaitAllWithTimeout.disabled = false
	$WaitAllWithCancellation.disabled = false
	$WaitAllCancel.disabled = true

func _run_wait_any_timer1():
	$WaitAnyTimer1.pressed = false
	yield(Task.wait(randf() * 1.5 + 0.5), "completed")
	$WaitAnyTimer1.pressed = true

func _run_wait_any_timer2():
	$WaitAnyTimer2.pressed = false
	yield(Task.wait(randf() * 1.5 + 0.5), "completed")
	$WaitAnyTimer2.pressed = true

func _run_wait_any_timer3():
	$WaitAnyTimer3.pressed = false
	yield(Task.wait(randf() * 1.5 + 0.5), "completed")
	$WaitAnyTimer3.pressed = true

func _on_WaitAny_pressed():
	$WaitAny.disabled = true
	$WaitAnyWithTimeout.disabled = true
	$WaitAnyWithCancellation.disabled = true

	var signal_specs := [_run_wait_any_timer1(), _run_wait_any_timer2(), _run_wait_any_timer3()]
	yield(Task.wait_any(signal_specs), "completed")

	$WaitAny.disabled = false
	$WaitAnyWithTimeout.disabled = false
	$WaitAnyWithCancellation.disabled = false

func _on_WaitAnyWithTimeout_pressed():
	$WaitAny.disabled = true
	$WaitAnyWithTimeout.disabled = true
	$WaitAnyWithCancellation.disabled = true

	var signal_specs := [_run_wait_any_timer1(), _run_wait_any_timer2(), _run_wait_any_timer3()]
	yield(Task.wait_any(signal_specs, 1.0), "completed")

	$WaitAny.disabled = false
	$WaitAnyWithTimeout.disabled = false
	$WaitAnyWithCancellation.disabled = false

func _on_WaitAnyWithCancellation_pressed():
	$WaitAny.disabled = true
	$WaitAnyWithTimeout.disabled = true
	$WaitAnyWithCancellation.disabled = true
	$WaitAnyCancel.disabled = false

	var cancel := CancellationTokenSource.new()
	cancel.cancel_after($WaitAnyCancel, "pressed")
	var signal_specs := [_run_wait_any_timer1(), _run_wait_any_timer2(), _run_wait_any_timer3()]
	yield(Task.wait_any(signal_specs, cancel.token), "completed")

	$WaitAny.disabled = false
	$WaitAnyWithTimeout.disabled = false
	$WaitAnyWithCancellation.disabled = false
	$WaitAnyCancel.disabled = true

func _on_Defer_pressed():
	$Defer.disabled = true
	var tree := .get_tree()
	var unit1 := Task.defer(tree.create_timer(randf() * 0.5), "timeout")
	var unit2 := Task.defer(tree.create_timer(randf() * 0.5), "timeout")
	var unit3 := Task.defer(tree.create_timer(randf() * 0.5), "timeout")
	$Defer.text = "1"
	yield(unit1.wait(), "completed")
	$Defer.text = "2"
	yield(unit2.wait(), "completed")
	$Defer.text = "3"
	yield(unit3.wait(), "completed")
	$Defer.text = "Task.defer()"
	$Defer.disabled = false

func _run_cancellable_counter(cancel_token: CancellationToken):
	var i := 0
	while not cancel_token.cancel_requested:
		$Cancellation.text = str(i)
		i += 1
		yield(Task.wait(0.1, cancel_token), "completed")
	$Cancellation.text = "Cancellation"

func _on_Cancellation_pressed():
	$Cancellation.disconnect("pressed", self, "_on_Cancellation_pressed")
	
	$Cancellation.text = "Counter continues until press this button"

	var cancel := CancellationTokenSource.new()
	cancel.cancel_after($Cancellation, "pressed")
	yield(Task.wait(1.5, cancel.token), "completed")

	yield(_run_cancellable_counter(cancel.token), "completed")
	$Cancellation.connect("pressed", self, "_on_Cancellation_pressed")
