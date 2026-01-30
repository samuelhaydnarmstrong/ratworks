extends ColorRect

signal dispatch_unit

var inventory = Dictionary({
	"worker": 0,
	"food": 0
})

var disInventory = Dictionary({
	"worker": 0,
	"food": 0
})

var items = Dictionary({
	"worker": {
		"cost": 10,
		"invNode": Label,
		"disNode": Label,
		"buyNode": Button,
		"disButton": Button
	},
	"food": {
		"cost": 5,
		"invNode": Label,
		"disNode": Label,
		"buyNode": Button,
		"disButton": Button
	},
})

func _on_close_pressed() -> void:
	visible = false

func _on_open_inventory() -> void:
	if(Globals.selectedNode and Globals.selectedNode.get("inventory")):
		inventory = Globals.selectedNode.get("inventory")
		for item in items:
			items[item].invNode.text = str(inventory[item])
			items[item].disNode.text = str(disInventory[item])
	visible = true

func buy_item(item: String) -> void:
	inventory[item] = inventory.get(item) + 1
	items.get(item).get("invNode").text = str(inventory.get(item))
	Globals.money = Globals.money - items.get(item).get("cost")
	_on_budget_timer_timeout()

func dispatch_item(item: String) -> void:
	inventory[item] = inventory.get(item) - 1
	items.get(item).get("invNode").text = str(inventory.get(item))
	
	disInventory[item] = disInventory.get(item) + 1
	items.get(item).get("disNode").text = str(disInventory.get(item))
	
	_on_budget_timer_timeout()

func _on_ready() -> void:
	$WorkerCost.text = str(items.get("worker").get("cost"))
	
	const TABLE_HEADINGS = ["Item", "Cost", "Buy", "Quantity", "Dispatch", "Quantity"]
	for HEADING in TABLE_HEADINGS:
		var itemLabelHeading = Label.new()
		itemLabelHeading.text = HEADING
		$InventoryAnchor.add_child(itemLabelHeading)
	
	for item in inventory:
		var itemLabel = Label.new()
		itemLabel.text = item
		$InventoryAnchor.add_child(itemLabel)
		
		var itemCost = Label.new()
		itemCost.text = str(items.get(item).get("cost"))
		$InventoryAnchor.add_child(itemCost)
		
		var itemBuy = Button.new()
		itemBuy.text = "Buy"
		itemBuy.connect("pressed", buy_item.bind(item))
		$InventoryAnchor.add_child(itemBuy)
		items[item].buyNode = itemBuy
		
		var itemQuantity = Label.new()
		itemQuantity.text = str(inventory.get(item))
		$InventoryAnchor.add_child(itemQuantity)
		items[item].invNode = itemQuantity
		
		var itemDispatch = Button.new()
		itemDispatch.text = ">"
		itemDispatch.connect("pressed", dispatch_item.bind(item))
		$InventoryAnchor.add_child(itemDispatch)
		items[item].disButton = itemDispatch
		
		var itemDispatchQuantity = Label.new()
		itemDispatchQuantity.text = str(disInventory.get(item))
		$InventoryAnchor.add_child(itemDispatchQuantity)
		items[item].disNode = itemDispatchQuantity

func _on_budget_timer_timeout() -> void:
	var isDisInvEmpty = true
	for item in items:
		if (items[item].invNode.text != str(inventory[item])):
			items[item].invNode.text = str(inventory[item])
		if items[item].cost > Globals.money:
			items[item].buyNode.disabled = true
		else:
			items[item].buyNode.disabled = false
		if inventory[item] > 0:
			items[item].disButton.disabled = false
		else:
			items[item].disButton.disabled = true
		if disInventory[item] > 0:
			isDisInvEmpty = false
	
	if isDisInvEmpty:
		$DispatchButton.disabled = true
	else:
		$DispatchButton.disabled = false

func _on_dispatch_button_pressed() -> void:
	dispatch_unit.emit(disInventory.duplicate())
	visible = false
	
	for item in disInventory:
		items[item].disNode.text = "0"
		disInventory[item] = 0
