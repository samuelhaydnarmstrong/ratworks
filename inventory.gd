extends ColorRect

signal dispatch_unit

var inventory = Dictionary({
	"worker": 0,
})

const WORKER_COST = 10

func _on_close_pressed() -> void:
	visible = false

func _on_open_inventory() -> void:
	visible = true

func _on_worker_buy_button_pressed() -> void:
	inventory.worker = inventory.worker + 1
	Globals.money = Globals.money - WORKER_COST
	$WorkerCount.text = str(inventory.worker)

func _on_ready() -> void:
	$WorkerCost.text = str(WORKER_COST)

func _on_budget_timer_timeout() -> void:
	if Globals.money > WORKER_COST:
		$WorkerBuyButton.disabled = false
	else:
		$WorkerBuyButton.disabled = true
	if inventory.worker > 0:
		$DispatchButton.disabled = false
	else:
		$DispatchButton.disabled = true

func _on_dispatch_button_pressed() -> void:
	dispatch_unit.emit()
	visible = false
