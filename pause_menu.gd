extends BaseMenu

const CREDIT_TEXT := "A game by LilPatch\nImageAsset: Brackeys Platformer Asset, Pixel Adventure 1\nSound effect: Brackeys Platformer Asset\nCode and Idea: LilPatch"

@onready var title_label: Label  = $CenterContainer/Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var coins_label: Label  = $CenterContainer/Panel/MarginContainer/VBoxContainer/CoinsLabel
@onready var buy_btn:     Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonContainer/ResetButton
@onready var cancel_btn:  Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonContainer/ResumeButton


func _ready() -> void:
	super()     # registers with MenuManager + sets PROCESS_MODE_ALWAYS

	title_label.text = "PAUSED"
	coins_label.text = CREDIT_TEXT
	buy_btn.text     = "Reset Game (Enter)"
	cancel_btn.text  = "Resume (ESC)"

	buy_btn.focus_mode    = Control.FOCUS_NONE
	cancel_btn.focus_mode = Control.FOCUS_NONE

	buy_btn.pressed.connect(_on_reset)
	cancel_btn.pressed.connect(close)

	get_tree().paused = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		get_viewport().set_input_as_handled()
		_on_reset()
	elif event.is_action_pressed("esc") or event.is_action_pressed("backspace"):
		get_viewport().set_input_as_handled()
		close()


func _on_reset() -> void:
	close()
	GameManager.full_reset()


# Override close to also unpause
func close() -> void:
	get_tree().paused = false
	super()
