extends Node

# All currently open menus
var _open_menus: Array[CanvasLayer] = []


func register(menu: CanvasLayer) -> void:
	if not _open_menus.has(menu):
		_open_menus.append(menu)


func unregister(menu: CanvasLayer) -> void:
	_open_menus.erase(menu)


func is_any_open() -> bool:
	return _open_menus.size() > 0


func is_open(menu_class) -> bool:
	for menu in _open_menus:
		if is_instance_of(menu, menu_class):
			return true
	return false


# Called by GameManager on reset or killzone —
# silently closes every open menu before scene reloads
func close_all() -> void:
	# Duplicate to avoid modifying array while iterating
	for menu in _open_menus.duplicate():
		menu.queue_free()
	_open_menus.clear()
	get_tree().paused = false
