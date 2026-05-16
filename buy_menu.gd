extends BaseMenu

const COSTS := {
	"jump":        5,
	"go_left":     10,
	"double_jump": 15,
}

const LABELS := {
	"jump":        "Jump",
	"go_left":     "Go Left",
	"double_jump": "Double Jump",
}

const PURCHASED_DELAY := 0.8

var ability:   String = ""
var mandatory: bool   = false

@onready var title_label: Label  = $CenterContainer/Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var coins_label: Label  = $CenterContainer/Panel/MarginContainer/VBoxContainer/CoinsLabel
@onready var buy_btn:     Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonContainer/BuyButton
@onready var cancel_btn:  Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonContainer/CancelButton


func _ready() -> void:
	super()     # calls BaseMenu._ready() — registers with MenuManager

	buy_btn.focus_mode    = Control.FOCUS_NONE
	cancel_btn.focus_mode = Control.FOCUS_NONE

	buy_btn.pressed.connect(_on_buy)
	cancel_btn.pressed.connect(close)

	cancel_btn.visible = not mandatory
	_refresh()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		get_viewport().set_input_as_handled()
		_on_buy()
	elif not mandatory and (event.is_action_pressed("esc") \
	or event.is_action_pressed("backspace")):
		get_viewport().set_input_as_handled()
		close()


func _refresh() -> void:
	var cost: int     = COSTS.get(ability, 0)
	var label: String = LABELS.get(ability, ability)
	title_label.text  = "Buy %s?" % label
	coins_label.text  = "Cost: %d coins" % cost
	buy_btn.disabled  = CoinManager.coins < cost


func _on_buy() -> void:
	var cost: int = COSTS.get(ability, 0)
	if not CoinManager.spend_coins(cost):
		return
	match ability:
		"jump":        CoinManager.jump_purchased        = true
		"go_left":     CoinManager.go_left_purchased     = true
		"double_jump": CoinManager.double_jump_purchased = true
	_show_purchased()


func _show_purchased() -> void:
	set_process_input(false)
	buy_btn.disabled   = true
	cancel_btn.visible = false
	buy_btn.text       = "Purchased!"
	coins_label.text   = ""
	await get_tree().create_timer(PURCHASED_DELAY).timeout
	close()
