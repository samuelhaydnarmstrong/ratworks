extends ColorRect

signal dispatch_unit

var inventory = Dictionary({
	"worker": 0
})

var transferInventory = Dictionary({
	"worker": 0
})

const WORKER_COST = 10

func _on_close_pressed() -> void:
	visible = false

func _on_open_inventory() -> void:
	if(Globals.selectedNode and Globals.selectedNode.get("inventory")):
		inventory = Globals.selectedNode.get("inventory")
		_on_budget_timer_timeout()
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
		$TransferWorkerButton.disabled = false
	else:
		$TransferWorkerButton.disabled = true
	if transferInventory.worker > 0:
		$DispatchButton.disabled = false
	else:
		$DispatchButton.disabled = true
		
	# General refresh
	$WorkerCount.text = str(inventory.worker)
	$DispatchWorkerCount.text = str(transferInventory.worker)

func _on_dispatch_button_pressed() -> void:
	dispatch_unit.emit(transferInventory.duplicate())
	visible = false
	
	transferInventory.worker = 0
	$DispatchWorkerCount.text = str(transferInventory.worker)

func _on_transfer_worker_button_pressed() -> void:
	inventory.worker = inventory.worker - 1
	$WorkerCount.text = str(inventory.worker)
	
	transferInventory.worker = transferInventory.worker + 1
	$DispatchWorkerCount.text = str(transferInventory.worker)
