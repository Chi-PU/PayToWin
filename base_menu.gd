class_name BaseMenu
extends CanvasLayer

# Every menu notifies MenuManager when it opens and closes
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	MenuManager.register(self)


func close() -> void:
	MenuManager.unregister(self)
	queue_free()
