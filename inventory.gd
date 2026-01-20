extends ColorRect

var inventory = Dictionary({
	"worker": 0,
})

const WORKER_COST = 500

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
