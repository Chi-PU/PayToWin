extends CanvasLayer

@onready var coin_icon:  TextureRect = $CoinDisplay/CoinIcon
@onready var coin_count: Label       = $CoinDisplay/CoinCount


func _ready() -> void:
	coin_count.text = "× %d" % CoinManager.get_coins()
	CoinManager.coins_changed.connect(_on_coins_changed)
	


func _on_coins_changed(new_coins: int) -> void:
	coin_count.text = "× %d" % new_coins
